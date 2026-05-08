package ma.ismagi.controller;

import org.junit.jupiter.api.*;

import java.net.CookieManager;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Integration tests for POST /validation.
 *
 * Prerequisites:
 *   - Server running at http://localhost:8081/EFM-Evenements
 *   - An AGENT_CONTROLE account exists with credentials below
 *   - For testValidCode_marksAsValide: a billet with code VALID_TEST_CODE
 *     and statut='ACTIF' must exist in the billet table
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ValidationControllerTest {

    private static final String BASE_URL       = "http://localhost:8081/EFM-Evenements";
    private static final String AGENT_EMAIL    = "agent@gmail.com";
    private static final String AGENT_PASSWORD = "123";
    private static final String VALID_TEST_CODE = "0354f7de-2d1a-4b18-9cf7-c251077d8bce";

    private static HttpClient authenticatedClient;

    @BeforeAll
    static void loginAsAgent() throws Exception {
        CookieManager cookieManager = new CookieManager();

        authenticatedClient = HttpClient.newBuilder()
                .cookieHandler(cookieManager)
                .followRedirects(HttpClient.Redirect.NORMAL)
                .build();

        String body = "email=" + URLEncoder.encode(AGENT_EMAIL, StandardCharsets.UTF_8)
                + "&password=" + URLEncoder.encode(AGENT_PASSWORD, StandardCharsets.UTF_8);

        HttpRequest loginReq = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/AuthController"))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> loginResp = authenticatedClient.send(loginReq, HttpResponse.BodyHandlers.ofString());

        // After redirect, the authenticated client should be on the scanner page
        assertTrue(
            loginResp.uri().toString().contains("scanner") || loginResp.statusCode() == 200,
            "Login failed — check AGENT_EMAIL/AGENT_PASSWORD and that the account exists in the DB"
        );

        System.out.println("[setup] Logged in as " + AGENT_EMAIL + " → landed on: " + loginResp.uri());
    }

    // -------------------------------------------------------------------------
    // Helper
    // -------------------------------------------------------------------------

    private HttpResponse<String> postValidation(HttpClient client, String qrCode) throws Exception {
        String body = "qrCode=" + URLEncoder.encode(qrCode, StandardCharsets.UTF_8);
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/validation"))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body))
                .build();
        return client.send(req, HttpResponse.BodyHandlers.ofString());
    }

    // -------------------------------------------------------------------------
    // Tests
    // -------------------------------------------------------------------------

    @Test
    @Order(1)
    void testGetMethod_returns405() throws Exception {
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/validation"))
                .GET()
                .build();
        HttpResponse<String> resp = authenticatedClient.send(req, HttpResponse.BodyHandlers.ofString());
        assertEquals(405, resp.statusCode());
        System.out.println("[test 1] GET /validation → " + resp.statusCode() + " (expected 405)");
    }

    @Test
    @Order(2)
    void testNoAuth_redirectsToLogin() throws Exception {
        HttpClient noAuthClient = HttpClient.newBuilder()
                .followRedirects(HttpClient.Redirect.NEVER)
                .build();

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/validation"))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString("qrCode=anything"))
                .build();

        HttpResponse<String> resp = noAuthClient.send(req, HttpResponse.BodyHandlers.ofString());

        assertEquals(302, resp.statusCode());
        assertTrue(resp.headers().firstValue("Location").orElse("").contains("login"));
        System.out.println("[test 2] No auth → " + resp.statusCode()
                + " redirect to: " + resp.headers().firstValue("Location").orElse("none"));
    }

    @Test
    @Order(3)
    void testEmptyCode_returnsInvalid() throws Exception {
        HttpResponse<String> resp = postValidation(authenticatedClient, "");
        assertEquals(200, resp.statusCode());
        assertTrue(resp.body().contains("\"INVALID\""), "Body was: " + resp.body());
        System.out.println("[test 3] Empty code → " + resp.body());
    }

    @Test
    @Order(4)
    void testNonExistentCode_returnsInvalid() throws Exception {
        HttpResponse<String> resp = postValidation(authenticatedClient, "this-code-does-not-exist-xyz-123");
        assertEquals(200, resp.statusCode());
        assertTrue(resp.body().contains("\"INVALID\""), "Body was: " + resp.body());
        System.out.println("[test 4] Non-existent code → " + resp.body());
    }

    @Test
    @Order(5)
    //@Disabled("Requires a row in billet with code='" + VALID_TEST_CODE + "' and statut='ACTIF'")
    void testValidCode_returnsOk() throws Exception {
        HttpResponse<String> resp = postValidation(authenticatedClient, VALID_TEST_CODE);
        assertEquals(200, resp.statusCode());
        assertTrue(resp.body().contains("\"OK\""), "Body was: " + resp.body());
        System.out.println("[test 5] Valid code → " + resp.body());
    }

    @Test
    @Order(6)
    //@Disabled("Run after testValidCode_returnsOk — same code should now be VALIDE")
    void testAlreadyUsedCode_returnsInvalid() throws Exception {
        HttpResponse<String> resp = postValidation(authenticatedClient, VALID_TEST_CODE);
        assertEquals(200, resp.statusCode());
        assertTrue(resp.body().contains("\"INVALID\""), "Body was: " + resp.body());
        System.out.println("[test 6] Already used code → " + resp.body());
    }
}
