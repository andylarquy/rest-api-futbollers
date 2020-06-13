package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Usuario
import java.util.ArrayList
import java.util.List
import javax.persistence.criteria.JoinType
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Accessors
class RepositorioUsuario extends Repositorio<Usuario> {

	public static RepositorioUsuario repoUsuario

	static def RepositorioUsuario getInstance() {
		if (repoUsuario === null) {
			repoUsuario = new RepositorioUsuario()
		}
		repoUsuario
	}

	def reset() {
		repoUsuario = null
	}

	private new() {}
	
	def coleccion(){
		
		queryTemplate(
			
			[criteria, query, from |
				from.fetch("invitaciones", JoinType.LEFT)
				return query
			], 
			[query | query.resultList]) as List<Usuario>
	}
	
	def existeUsuarioConMail(String email){
		coleccion.exists[usuario | usuario.tieneEsteMail(email)]
	}

	def searchById(Long idUsuario) {
		queryTemplate(
			[criteria, query, from |
				from.fetch("invitaciones", JoinType.LEFT)
				query.where(criteria.equal(from.get("idUsuario"), idUsuario))
				return query
			], 
			[query | query.singleResult]) as Usuario
	}
	
	def getUsuarioConCredenciales(String email, String password){
	
	queryTemplate([criteria, query, from |

			query.where(
				criteria.equal(from.get("email"), email),
				criteria.equal(from.get("password"), password)
			)
		], [query | query.singleResult]) as Usuario
		
	}
	
	override entityType() {
		Usuario
	}
	
	def getAmigosDelUsuario(Long idUsuario){
		val usuario = queryTemplate([criteria, query, from |
			from.fetch("amigos", JoinType.LEFT)	
			query.where(criteria.equal(from.get("idUsuario"), idUsuario))
			return query
		], 
		
		[query | query.singleResult]) as Usuario
		
		usuario.amigos
	}
	
	def getCandidatosDelUsuario(Usuario usuario) {
		queryTemplate([criteria, query, from |
			
			
			val criteriosWhere = new ArrayList()
			
			if (!usuario.amigos.empty) {
				criteriosWhere.add(criteria.not(from.get("idUsuario").in(usuario.idDeSusAmigos.toSet)))
			}

			criteriosWhere.add(criteria.notEqual(from.get("idUsuario"), usuario.idUsuario))
			
			query.where(criteriosWhere)
		], [query | query.resultList.toSet])

	}
	
	def notificacionesDelUsuario(Long idUsuario) {
		val usuario = queryTemplate([criteria, query, from |
				from.fetch("invitaciones", JoinType.LEFT)
				query.where(criteria.equal(from.get("idUsuario"), idUsuario))
				return query
			], 
			[query | query.singleResult]) as Usuario
			
			
			return usuario.invitaciones
	}
	

	//TODO: Hacer en formato de query	
	def getUsuariosEnElRangoDe(Usuario usuarioBuscado, int rangoDeBusqueda, String sexoBuscado, String posicionBuscada) {
		
		val filtroPorRango = coleccion.filter[usuario | 
			usuario.estaDentroDelRango(usuarioBuscado.getUbicacion, rangoDeBusqueda)
		]
		
		if(!sexoBuscado.equals("Mixto")){
			return filtroPorRango.filter[usuario | usuario.tieneSexo(sexoBuscado)]
		}
		
		return filtroPorRango
		
	}
	
	def searchByIdConAmigos(Long idUsuario) {
		queryTemplate(
			[criteria, query, from |
				from.fetch("amigos", JoinType.LEFT)
				query.where(criteria.equal(from.get("idUsuario"), idUsuario))
				return query
			], 
			[query | query.singleResult]) as Usuario
	}
	
}