document.addEventListener('DOMContentLoaded', function () {

    document.getElementById('btnScan').addEventListener('click', function() {

        const qrCodeValue = document.getElementById('qrInput').value;
        const resultDiv = document.getElementById('resultMessage');

        if (!qrCodeValue) {
            return;
        }

        fetch(APP_CONTEXT_PATH + '/validation', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            credentials: 'same-origin',
            body: 'qrCode=' + encodeURIComponent(qrCodeValue)
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            if (data.status === 'OK') {
                resultDiv.style.color = 'green';
                resultDiv.innerText = 'Accès validé.';
            } else {
                resultDiv.style.color = 'red';
                resultDiv.innerText = 'Accès refusé : Billet invalide ou déjà consommé.';
            }

            document.getElementById('qrInput').value = '';
            document.getElementById('qrInput').focus();
        })
        .catch(function(error) {
            resultDiv.style.color = 'red';
            resultDiv.innerText =
                'Erreur de connexion au serveur. (error:' + error.message + ')';
        });

    });

});