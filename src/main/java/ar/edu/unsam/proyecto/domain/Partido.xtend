package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.exceptions.InsufficientCandidates
import ar.edu.unsam.proyecto.exceptions.ObjectAlreadyExists
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioNotificacion
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Period
import java.util.HashSet
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
class Partido {

	@JsonView(ViewsPartido.ListView)
	@Id@GeneratedValue
	Long idPartido
	
	
//TODO - En principio parece que no hace falta pero lo dejamos por las dudas
//	@JsonView(ViewsPartido.DefaultView)
//	transient Usuario owner

	@JsonView(ViewsPartido.ListView)
	@ManyToOne
	Equipo equipo1

	@JsonView(ViewsPartido.ListView)
	@ManyToOne
	Equipo equipo2

	@JsonView(ViewsPartido.DefaultView)
	@ManyToOne
	Empresa empresa

	@JsonView(ViewsPartido.DetallesView)
	@ManyToOne
	Cancha canchaReservada

	@Column()
	@JsonView(ViewsPartido.DetallesView)
	LocalDateTime fechaDeReserva
	
	@JsonView(ViewsPartido.DetallesView)
	@ManyToOne
	Promocion promocion
	
	@Transient
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	
	@Transient
	transient RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance
	
	@Transient
	transient RepositorioCancha repoCancha = RepositorioCancha.instance
	
	@Transient
	transient RepositorioEmpresa repoEmpresa = RepositorioEmpresa.instance
	
	
	transient static val ID_EQUIPO_TEMPORAL = -2
	
	def precioTotal(){
		canchaReservada.precio * (1 - porcentajeDescuento / 100)
	}
	
	def porcentajeDescuento(){
		promocion !== null ? promocion.porcentajeDescuento : return 0
	}

	def validar() {
		
		if (fechaDeReserva === null){
			throw new Exception('El partido debe tener una fecha de reserva')
		}
		
		equipo1.validar
		equipo2.validar
		empresa.validar
		canchaReservada.validar
	}
	

	// TODO: Separar en equipo y equipo completo
	def participaUsuario(Usuario usuario) {
		equipo1.participaUsuario(usuario) || equipo2.participaUsuario(usuario)
	}
	
	def validarFechaEstaLibre(LocalDateTime fecha) {
		if(sonLaMismaFecha(fechaDeReserva.toLocalDate, fecha.toLocalDate) && laDiferenciaEsMenorAUnaHora(fechaDeReserva, fecha)){
			throw new ObjectAlreadyExists('Ya existe una reserva para esa fecha y hora')
		} 
	}

	def sonLaMismaFecha(LocalDate fecha1, LocalDate fecha2){
		Period.between(fecha1, fecha2).days == 0
	}
	
	def laDiferenciaEsMenorAUnaHora(LocalDateTime fecha1, LocalDateTime fecha2){
		Math.abs(Duration.between(fecha1, fecha2).toMinutes) < 60
	}
	
	def tieneEquipoTemporal() {
		return equipo1.idEquipo == ID_EQUIPO_TEMPORAL || equipo2.idEquipo == ID_EQUIPO_TEMPORAL
	}
	
	def mapearJugadoresTemporales() {
		
		if(this.tieneEquipoTemporal){
			jugadoresTemporalesDelPartido.forEach[jugador | buscarJugadorPorGPS(jugador, equipo1.owner)]
		}
	}

	def void buscarJugadorPorGPS(Usuario usuarioABuscar, Usuario usuarioOwner){
		val int rangoDeBusqueda = Integer.parseInt(usuarioABuscar.email)
		val sexoBuscado = usuarioABuscar.sexo
		val posicionBuscada = usuarioABuscar.posicion
		
		val candidatos = repoUsuario.getUsuariosEnElRangoDe(usuarioOwner, rangoDeBusqueda, sexoBuscado, posicionBuscada)
		
		if(candidatos.size >= jugadoresTemporalesDelPartido.size){
			
			candidatos.forEach[candidato | 
				val invitacion = new Notificacion()
				invitacion.partido = this
				invitacion.usuario = candidato
				
				repoNotificacion.agregarNotificacion(invitacion)
			]
		
		}else{
			throw new InsufficientCandidates("No se han encontrado suficientes jugadores con esos parametros de busqueda")
		}
		
	}
	

	
	def jugadoresTemporalesDelPartido(){
		val jugadores = jugadoresDelPartido
		return jugadores.filter[jugador | jugador.esIntegranteDesconocido].toSet
	}
	
	def jugadoresDelPartido(){
		val jugadores = new HashSet()
		jugadores.addAll(equipo1.integrantes)
		jugadores.addAll(equipo2.integrantes)
		
		return jugadores
	}
	
	def void jugadoresConocidos() {}
	
	def mapearJugadoresConocidos() {
		equipo1.mapearJugadoresConocidos
		equipo2.mapearJugadoresConocidos
	}
	
	def eliminarJugadoresTemporales() {
		equipo1.integrantes.removeIf[integrante | integrante.esIntegranteDesconocido]
		equipo2.integrantes.removeIf[integrante | integrante.esIntegranteDesconocido]
	}
	
	def prepararParaPersistir() {
		eliminarJugadoresTemporales()
		asignarNombreEquipos()
		asignarIdEquiposTemporales()
		mapearCancha()
	}
	
	def asignarNombreEquipos(){
		equipo1.asignarNombreTemporal
		equipo2.asignarNombreTemporal
	}
	
	def asignarIdEquiposTemporales(){
		equipo1.asignarIdEquipoTemporal
		equipo2.asignarIdEquipoTemporal
	}
	
	def mapearCancha(){
		canchaReservada = repoCancha.searchById(canchaReservada.idCancha)
	}
	
	def mapearEmpresa(){
		empresa = repoEmpresa.searchById(empresa.idEmpresa)
	}
	
}
