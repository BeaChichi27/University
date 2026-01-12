from flask import Blueprint, request, jsonify
from app.controller.impiegato_controller import ImpiegatoController
from database import get_db

impiegato_bp = Blueprint("impiegato", __name__, url_prefix="/api/impiegati")

@impiegato_bp.route("/", methods=["POST"])
def aggiungi_impiegato():
    with next(get_db()) as db:
        controller = ImpiegatoController(db)
    data = request.json
    try:
        controller.aggiungi_impiegato(
            data["cf"], data["nome"], data["cognome"], data["datanascita"], data["codicecon"]
        )
        return jsonify({"message": "Impiegato aggiunto con successo"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@impiegato_bp.route("/<string:cf>", methods=["DELETE"])
def rimuovi_impiegato(cf):
    with next(get_db()) as db:
        controller = ImpiegatoController(db)
    try:
        controller.rimuovi_impiegato(
            cf
        )
        return jsonify({"message": "Impiegato rimosso con successo"}), 200
    except Exception as e:
        return jsonify({"error":str(e)}), 400
    
@impiegato_bp.route("/<string:cf>/promuovi/<string:merito>", methods=["PATCH"])
def promuovi_impiegato(cf, merito):
    with next(get_db()) as db:
        controller = ImpiegatoController(db)
    try:
        merito_bool:bool = merito.lower() == 'true'
        controller.promuovi_impiegato(cf, merito_bool)
        return jsonify({"message": f"Impiegato con CF {cf} promosso"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

    
@impiegato_bp.route("/<string:cf>/laboratori", methods=["GET"])
def carica_afferenze(cf):
    with next(get_db()) as db:
        controller = ImpiegatoController(db)
    try:
        laboratori = controller.carica_afferenze(cf)
        return jsonify(laboratori), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400
    
@impiegato_bp.route("/<string:cf>/promozioni", methods=["GET"])
def get_promozioni(cf):
    with next(get_db()) as db:
        controller = ImpiegatoController(db)
    try:
        promozioni = controller.get_promozioni(cf)
        return jsonify(promozioni), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400

    
@impiegato_bp.route("/<string:cf>/progetti", methods=["GET"])
def get_progetto(cf):
    try:
        with next(get_db()) as db:
            controller = ImpiegatoController(db)
            progetto = controller.get_progetti(cf)
        if progetto:
            return jsonify({"progetto": progetto}), 200
        else:
            return jsonify({"message": f"Nessun progetto associato all'impiegato {cf}"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400