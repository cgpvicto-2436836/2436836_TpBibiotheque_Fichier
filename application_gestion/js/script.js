const API_URL = 'https://two436836-tpbibiotheque-serviceweb.onrender.com/api';

function afficherMessage(id, texte, type) {
    const element = document.getElementById(id);

    element.textContent = texte;
    element.className = 'message ' + type;
    element.style.display = 'block';
}

// INSCRIPTION
document.getElementById('formulaire-inscription')
.addEventListener('submit', async function (e) {

    e.preventDefault();

    let usager = {
        nom_bibliotheque: document.getElementById('inscription-nom').value,
        courriel: document.getElementById('inscription-courriel').value,
        mot_de_passe: document.getElementById('inscription-mdp').value
    };

    try {

        let response = await fetch(`${API_URL}/usagers`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify(usager)
        });

        if (!response.ok) {
            console.error('Erreur HTTP:', response.status);

            afficherMessage(
                'msg-inscription',
                'Erreur lors de l’inscription',
                'erreur'
            );

            return;
        }

        // Conversion JSON
        let data = await response.json();

        console.log(data);

        afficherMessage(
            'msg-inscription',
            'Compte créé avec succès !',
            'succes'
        );

        document.getElementById('valeur-cle-inscription')
            .textContent = data.cle_api;

        document.getElementById('cle-inscription')
            .style.display = 'block';

    } catch (err) {

        console.error('Erreur réseau:', err);

        afficherMessage(
            'msg-inscription',
            'Erreur réseau',
            'erreur'
        );
    }
});


// RÉCUPÉRATION DE CLÉ API
document.getElementById('formulaire-cle')
.addEventListener('submit', async function (e) {

    e.preventDefault();

    const courriel = document.getElementById('cle-courriel').value;

    const mot_de_passe = document.getElementById('cle-mdp').value;

    const nouvelle =
        document.getElementById('cle-nouveau').checked ? 1 : 0;

    try {

        let url =
            `${API_URL}/usagers/cle?courriel=${encodeURIComponent(courriel)}`
            + `&mot_de_passe=${encodeURIComponent(mot_de_passe)}`
            + `&nouvelle=${nouvelle}`;

        let response = await fetch(url);

        if (!response.ok) {

            console.error('Erreur HTTP:', response.status);

            afficherMessage(
                'msg-cle',
                'Identifiants invalides',
                'erreur'
            );

            return;
        }

        let data = await response.json();

        console.log(data);

        afficherMessage(
            'msg-cle',
            'Clé API récupérée avec succès !',
            'succes'
        );

        document.getElementById('valeur-cle-recuperee')
            .textContent = data.cle_api;

        document.getElementById('cle-recuperee')
            .style.display = 'block';

    } catch (err) {

        console.error('Erreur réseau:', err);

        afficherMessage(
            'msg-cle',
            'Erreur réseau',
            'erreur'
        );
    }
});