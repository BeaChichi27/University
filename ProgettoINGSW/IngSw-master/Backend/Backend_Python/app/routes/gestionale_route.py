from flask import Blueprint, jsonify, request
from app.controller.gestionale_controller import GestionaleController
from database import get_db

gestionale_bp = Blueprint("gestionale", __name__, url_prefix="/api/gestionale")

@gestionale_bp.route("/impiegati", methods=["GET"])
def get_impiegati():
    with next(get_db()) as db:
        controller = GestionaleController(db)
    try:
        impiegati = controller.get_impiegati_db()
        impiegati_dict = [imp.to_dict() for imp in impiegati]
        return jsonify(impiegati_dict)
    except Exception as e:
        db.rollback()
        raise RuntimeError(f"Errore nel recupero degli impiegati: {e}")

@gestionale_bp.route("/laboratori", methods=["GET"])
def get_laboratori():
    with next(get_db()) as db:
        controller = GestionaleController(db)
    try:
        laboratori = controller.get_laboratori_db()
        laboratori_dict = [lab.to_dict() for lab in laboratori]
        return jsonify(laboratori_dict)
    except Exception as e:
        db.rollback()
        raise RuntimeError(f"Errore nel recupero degli laboratori: {e}")

@gestionale_bp.route("/promozioni", methods=["GET"])
def get_promozioni():
    with next(get_db()) as db:
        controller = GestionaleController(db)
    try:
        promozioni = controller.get_promozioni_db()
        promozioni_dict = [prom.to_dict() for prom in promozioni]
        return jsonify(promozioni_dict)
    except Exception as e:
        db.rollback()
        raise RuntimeError(f"Errore nel recupero delle promozioni: {e}")

@gestionale_bp.route("/progetti", methods=["GET"])
def get_progetti():
    with next(get_db()) as db:
        controller = GestionaleController(db)
    try:
        progetti = controller.get_progetti_db()
        progetti_dict = [prog.to_dict() for prog in progetti]
        return jsonify(progetti_dict)
    except Exception as e:
        db.rollback()
        raise RuntimeError(f"Errore nel recupero dei progetti: {e}")