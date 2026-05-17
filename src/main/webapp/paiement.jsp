<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Paiement - EventTix</title>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 flex items-center justify-center p-5 py-12">
        <div class="w-full max-w-lg bg-white border border-gray-200 rounded-xl p-6 sm:p-10 shadow-sm">

            <div class="text-center mb-8 border-b border-gray-100 pb-6">
                <h1 class="font-bold text-3xl text-gray-950 mb-2">Paiement Sécurisé 🔒</h1>
                <p class="text-gray-500 font-medium">Finalisez votre commande en toute tranquillité.</p>
            </div>

            <div class="bg-gray-50 border border-gray-200 rounded-lg p-5 mb-8 flex justify-between items-center">
                <span class="font-bold text-gray-700 uppercase tracking-wide">Total à payer</span>
                <span class="font-black text-2xl text-primary-500">${montant} MAD</span>
            </div>

            <c:if test="${not empty erreurPaiement}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r-md">
                    <p class="text-red-800 font-bold">${erreurPaiement}</p>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/commandes" method="POST" class="flex flex-col gap-6">
                <input type="hidden" name="idEvenement" value="${idEvenement}">
                <input type="hidden" name="place" value="${placeChoisie}">
                <input type="hidden" name="quantite" value="${quantite}">
                <input type="hidden" name="montant" value="${montant}">

                <div>
                    <label for="cardNumber" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Numéro de carte</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000" class="w-full h-14 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-bold tracking-widest outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                </div>

                <div class="grid grid-cols-2 gap-5">
                    <div>
                        <label for="expiry" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Expiration</label>
                        <input type="text" id="expiry" name="expiry" placeholder="MM/YY" class="w-full h-14 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-bold text-center tracking-widest outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                    </div>
                    <div>
                        <label for="cvv" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Code CVV</label>
                        <input type="text" id="cvv" name="cvv" placeholder="123" class="w-full h-14 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-bold text-center tracking-widest outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                    </div>
                </div>

                <button type="submit" class="w-full h-14 mt-4 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-widest text-white bg-primary-500 hover:bg-[#C1122B] transition-colors text-lg shadow-sm">
                    Payer ${montant} MAD
                </button>
            </form>

            <div class="mt-8 text-center flex items-center justify-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
                <p class="text-xs text-gray-400 font-semibold uppercase tracking-widest">Paiement crypté SSL 256-bit</p>
            </div>

        </div>
    </main>
</body>
</html>