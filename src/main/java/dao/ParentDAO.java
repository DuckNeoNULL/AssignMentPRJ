package dao;

import model.Parents;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

@Transactional
public class ParentDAO {
    
    @PersistenceContext(unitName = "KidSocialPU")
    private EntityManager em;
    
    public void create(Parents parent) {
        em.persist(parent);
    }
    
    public Parents findByEmail(String email) {
        return em.createQuery("SELECT p FROM Parent p WHERE p.email = :email", Parents.class)
                .setParameter("email", email)
                .getResultStream()
                .findFirst()
                .orElse(null);
    }
    
    public boolean emailExists(String email) {
        return findByEmail(email) != null;
    }
}