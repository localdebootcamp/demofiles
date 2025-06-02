from sqlalchemy.dialects.postgresql import insert

def store_data_wth_idempotency(data):
    session = Session()
    try:
        for records in data:
            stmt = insert(user).values(name=records['user_id'], age=records['age'],email=records['email'])
            stmt = stmt.on_conflict_do_nothing(index_elements=['user_id'])
            session.execute(stmt)
        session.commit()
    except Exception as e:
        session.rollback()
        logging.error(f"Error storing data: {e}")
    finally:
        session.close()