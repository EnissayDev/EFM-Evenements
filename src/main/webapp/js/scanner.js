document.getElementById('btnScan').addEventListener('click', function() {
    const qrCodeValue = document.getElementById('qrInput').value;
    const resultDiv = document.getElementById('resultMessage');

    if (!qrCodeValue) {
        return;
    }

    fetch('ValidationController', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'qrCode=' + encodeURIComponent(qrCodeValue)
    })
    .then(response => response.json())
    .then(data => {
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
    .catch(error => {
        resultDiv.style.color = 'red';
        resultDiv.innerText = 'Erreur de connexion au serveur.';
    });
});