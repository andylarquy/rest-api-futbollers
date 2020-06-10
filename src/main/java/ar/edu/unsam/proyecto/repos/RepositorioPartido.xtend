package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import java.time.LocalDateTime
import java.util.List
import javax.persistence.criteria.JoinType
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

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

	Long idAutoincremental = Long.valueOf(1)

	def asignarIdPartido(Partido partido) {
		partido.idPartido = idAutoincremental
		idAutoincremental++
	}

	private new() {}
	
	def coleccion(){
		
		queryTemplate(
			[criteria, query, from |
				from.fetch("equipo1", JoinType.LEFT)
				from.fetch("equipo2", JoinType.LEFT)
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
		// TODO: Revisar si esta query hace las cosas bien
		
		queryTemplate(
			[criteria, query, from |
				
				//PRIMER JOIN: PARTIDO -> EQUIPOS
				val tablaEquipo1 = from.join("equipo1", JoinType.LEFT)
				val tablaEquipo2 = from.join("equipo2", JoinType.LEFT)
		
				//SEGUNDO JOIN: EQUIPO -> INTEGRANTES
				val integrantesEquipo1 = tablaEquipo1.joinSet("integrantes", JoinType.LEFT)
				val integrantesEquipo2 = tablaEquipo2.joinSet("integrantes", JoinType.LEFT)
				
				val criterio1 = criteria.equal(integrantesEquipo1.get("idUsuario"), usuario.idUsuario)
				val criterio2 = criteria.equal(integrantesEquipo2.get("idUsuario"), usuario.idUsuario)
				
				val criterio3 = criteria.equal(tablaEquipo1.get("owner"), usuario.idUsuario)
				val criterio4 = criteria.equal(tablaEquipo1.get("owner"), usuario.idUsuario)
				
				val criterio5 = criteria.or(criterio1, criterio2, criterio3, criterio4)
				val criterio6 = criteria.equal(from.get("estado"), true)
				
				query.where(criteria.and(criterio5, criterio6))
				return query
			],
		
		[query | query.resultList]) as List<Partido>
		 
	}
	
	def void validarFechaCancha(LocalDateTime fecha){
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

	def crearPartido(Partido partido){
		if(partido.idPartido === null){
			this.asignarIdPartido(partido)
			this.create(partido)
		}
	}
	
}