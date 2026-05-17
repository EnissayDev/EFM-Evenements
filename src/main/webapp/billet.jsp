<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Votre Billet - EventTix</title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        @media print {
            body { background-color: #fff !important; }
            header, nav, .no-print { display: none !important; }
            main { padding: 0 !important; margin: 0 !important; justify-content: flex-start !important; }
            .ticket-card { box-shadow: none !important; border: 2px solid #000 !important; margin-top: 20px; }
        }
    </style>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 flex flex-col items-center justify-center p-5 py-12">

        <div class="ticket-card w-full max-w-md bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-lg flex flex-col">

            <div class="bg-gray-950 text-white p-6 text-center">
                <h2 class="font-bold text-2xl tracking-widest uppercase mb-1">Billet Confirmé</h2>
                <p class="text-gray-400 text-sm font-medium">Votre accès est garanti</p>
            </div>

            <div class="p-6 pb-8 bg-white flex flex-col gap-5 border-b-2 border-dashed border-gray-200 relative">

                <div class="absolute -bottom-3 -left-3 w-6 h-6 bg-gray-50 rounded-full border-t border-r border-gray-200 z-10 hidden sm:block"></div>
                <div class="absolute -bottom-3 -right-3 w-6 h-6 bg-gray-50 rounded-full border-t border-l border-gray-200 z-10 hidden sm:block"></div>

                <div>
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-1">Événement</p>
                    <h3 class="font-bold text-xl text-gray-900 leading-tight">${evenement.titre}</h3>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-1">Date</p>
                        <p class="font-semibold text-gray-900">${evenement.date}</p>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-1">Lieu</p>
                        <p class="font-semibold text-gray-900">${evenement.lieu}</p>
                    </div>
                </div>

                <div>
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-1">Participant</p>
                    <p class="font-semibold text-gray-900 uppercase">${sessionScope.user.prenom} ${sessionScope.user.nom}</p>
                </div>
            </div>

            <div class="p-8 bg-white flex flex-col items-center justify-center">
                <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-6">Présentez ce code à l'entrée</p>

                <div id="qrcode" class="p-3 bg-white border border-gray-200 rounded-xl shadow-sm mb-6 flex justify-center items-center"></div>

                <p class="font-mono text-lg font-bold tracking-widest text-gray-900 bg-gray-100 px-6 py-2 rounded-md">
                    ${billet.code}
                </p>
            </div>
        </div>

        <div class="w-full max-w-md mt-6 flex flex-col sm:flex-row gap-3 no-print">
            <button onclick="window.print()" class="flex-1 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide h-14 text-white bg-primary-500 hover:bg-[#C1122B] transition-colors">
                🖨️ Imprimer
            </button>
            <a href="${pageContext.request.contextPath}/BilletController?action=mesBillets" class="flex-1 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide h-14 text-gray-900 bg-gray-200 hover:bg-gray-300 transition-colors text-center">
                Mes billets
            </a>
        </div>

    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var codeBillet = "${billet.code}";
            if (!codeBillet) {
                codeBillet = "CODE-TEST-INVALIDE";
            }

            // Génération du QR Code
            new QRCode(document.getElementById("qrcode"), {
                text: codeBillet,
                width: 220,
                height: 220,
                colorDark : "#111111", // Utilisation du noir Tickets.ca (remplace l'ancien bleu foncé)
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.H
            });
        });
    </script>
</body>
</html>