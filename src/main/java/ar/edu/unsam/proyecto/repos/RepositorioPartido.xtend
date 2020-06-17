package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Cancha
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
	
	override entityId(Partido partido){
		partido.idPartido
	}

	private new() {}
	
	def coleccion(){
		
		queryTemplate(
			[criteria, query, from |
				from.fetch("equipo1", JoinType.LEFT)
				from.fetch("equipo2", JoinType.LEFT)
				query.where(criteria.equal(from.get("estado"), true))
				return query
			], 
			[query | query.resultList]) as List<Partido>
	}
	
	def searchById(Long idPartido) {
		return coleccion.filter[partido|partido.getIdPartido == idPartido].head
	}

	
	def void validarFechaCancha(LocalDateTime fecha, Cancha cancha){
		coleccion.forEach[it.validarFechaEstaLibre(fecha, cancha)]
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
	
	def partidosOwnereadosDelUsuario(Usuario usuario) {
		coleccion.filter[partido | partido.equipo1.esOwner(usuario)].toList
	}
	
}