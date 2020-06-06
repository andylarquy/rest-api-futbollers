package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import java.time.LocalDateTime
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import javax.persistence.criteria.JoinType
import java.util.ArrayList

@Observable
@Accessors
class RepositorioPartido extends Repositorio<Partido> {

	public static RepositorioPartido repoPartido

	static def RepositorioPartido getInstance() {
		if (repoPartido === null) {
			repoPartido = new RepositorioPartido()
		}
		repoPartido
	}

	def reset() {
		repoPartido = null
	}

	private new() {}
	
	def coleccion(){
		
		queryTemplate(
			[criteria, query, from |
				//from.fetch("equipo1", JoinType.LEFT)
				//from.fetch("equipo2", JoinType.LEFT)
				//from.fetch("empresa", JoinType.LEFT)
				//from.fetch("canchaReservada", JoinType.LEFT)
				//from.fetch("promocion", JoinType.LEFT)
				query.where(criteria.equal(from.get("estado"), true))
				return query
			], 
			[query | query.resultList]) as List<Partido>
	}
	
	def searchById(Long idPartido) {
		return coleccion.filter[partido|partido.getIdPartido == idPartido].head
	}
	
	def getPartidosDelUsuario(Usuario usuario){
		
		queryTemplate(
			[criteria, query, from |
		
				val criteriosWhere = new ArrayList()
				
				//PRIMER JOIN: PARTIDO -> EQUIPOS
				val tablaEquipo1 = from.join("equipo1", JoinType.INNER)
				val tablaEquipo2 = from.join("equipo2", JoinType.INNER)
		
				//SEGUNDO JOIN: EQUIPO -> INTEGRANTES
				val integrantesEquipo1 = tablaEquipo1.joinSet("integrantes", JoinType.INNER)
				val integrantesEquipo2 = tablaEquipo2.joinSet("integrantes", JoinType.INNER)
				
				criteriosWhere.add(criteria.equal(integrantesEquipo1.get("idUsuario"), usuario.idUsuario))
				criteriosWhere.add(criteria.equal(integrantesEquipo2.get("idUsuario"), usuario.idUsuario))
				criteriosWhere.add(criteria.equal(from.get("estado"), true))
				
				query.where(criteriosWhere)
				
				return query
			],
		
		[query | query.resultList]) as List<Partido>
		
	}
	
	def validarFechaCancha(LocalDateTime fecha){
		coleccion.forEach[it.validarFechaEstaLibre(fecha)]
	}
	
	override entityType() {
		Partido
	}
	
	//Baja logica
	def eliminarPartido(Partido partido){
		partido.estado = false
		update(partido)
		
	}

	
	
}