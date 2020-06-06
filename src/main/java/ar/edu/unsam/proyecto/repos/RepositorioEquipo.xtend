package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Usuario
import java.util.List
import javax.persistence.criteria.JoinType
import javax.persistence.NoResultException

class RepositorioEquipo extends Repositorio<Equipo> {
	public static RepositorioEquipo repoEquipo

	static def RepositorioEquipo getInstance() {
		if (repoEquipo === null) {
			repoEquipo = new RepositorioEquipo()
		}
		repoEquipo
	}

	def reset() {
		repoEquipo = null
	}

	private new() {}
	
	def coleccion(){
		
		queryTemplate(
			[criteria, query, from |
				//from.fetch("owner", JoinType.LEFT)
				from.fetch("integrantes", JoinType.LEFT)
				return query
			], 
			[query | query.resultList]) as List<Equipo>
	}

	def searchById(Long equipoId) {
		
		queryTemplate(
			[criteria, query, from |
				query.where(criteria.equal(from.get("idEquipo"), equipoId))
				return query
			],
		
			[query | query.singleResult]) as Equipo
		
	}

	def getEquiposDelUsuario(Usuario usuario) {
		queryTemplate(
			[criteria, query, from |
				
				from.fetch("integrantes", JoinType.LEFT)
				val tablaIntegrantes = from.joinSet("integrantes", JoinType.INNER)
				query.where(criteria.equal(tablaIntegrantes.get("idUsuario"), usuario.idUsuario))
		
				return query
			],
		
			[query | query.resultList]) as List<Equipo>
		
	}
	
	
	def noExisteEquipoConId(String idEquipo) {
		!coleccion.exists[it.getIdEquipo.equals(idEquipo)]
	}
	
	def searchEquipoById(String idBuscado){
		coleccion.filter[it.getIdEquipo.equals(idBuscado)].head
	}
	
	override entityType() {
		Equipo
	}
	
	//TODO: Un Try catch quizas no es lo mas adecuado
	def createIfNotExists(Equipo equipo) {
		try{
			repoEquipo.searchById(equipo.idEquipo)	
		}catch(NoResultException e){
			
			repoEquipo.create(equipo)
			
		}
		
	}
	
	
}
