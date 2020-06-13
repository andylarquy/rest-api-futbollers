package ar.edu.unsam.proyecto.repos

import javax.persistence.EntityManagerFactory
import javax.persistence.Persistence
import javax.persistence.PersistenceException
import javax.persistence.TypedQuery
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Root
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Repositorio<T> {

	static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("Futbollers")

	def getEntityManager() {
		entityManagerFactory.createEntityManager
	}

	def queryTemplate((CriteriaBuilder, CriteriaQuery<T>, Root<T>)=>CriteriaQuery<T> consulta,
		(TypedQuery<T>)=>Object resultType) {
		val entity = entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery as CriteriaQuery<T>
			val from = query.from(entityType)

			query.select(from).distinct(true)

			consulta.apply(criteria, query, from)
			resultType.apply(entity.createQuery(query))
			
		} catch (Exception e) {
			throw e
		} finally {
			entity.close
		}
	}

	def Class<T> entityType()
	def Long entityId(T t)

	def create(T t) {
		val entityManager = this.entityManager
		try {
			entityManager => [
				transaction.begin
				// ahora soy transient
				persist(t)
				transaction.commit
			// ahora persistent
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager.close
		// ahora soy detached
		}
	}

	def update(T t) {
		val entityManager = this.entityManager
		try {
			entityManager => [
				transaction.begin
				merge(t)
				transaction.commit
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager?.close
		}
	}
	
	def delete(T t){
		val entityManager = this.entityManager
		try {
			entityManager.transaction.begin
			val entity = entityManager.find(entityType, entityId(t))
			entityManager.remove(entity)
			entityManager.transaction.commit
			
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager?.close
		}
	}

}
