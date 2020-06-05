package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.exceptions.ObjectAlreadyExists
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import com.fasterxml.jackson.annotation.JsonView
import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Period
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import javax.persistence.Transient
import java.util.HashSet
import javax.naming.InsufficientResourcesException
import ar.edu.unsam.proyecto.exceptions.InsufficientCandidates

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
	
	transient static val ID_EQUIPO_TEMPORAL = -2
	transient static val ID_EQUIPO_GPS = -1
	
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
	
	def mapearEquipoTemporal() {
		
		if(this.tieneEquipoTemporal){
		
			equipo1.getUsuariosTemporales.forEach[jugador | buscarJugadorPorGPS(jugador, equipo1.owner)]
			equipo2.getUsuariosTemporales.forEach[jugador | buscarJugadorPorGPS(jugador, equipo2.owner)]
			
		}
	}

	def void buscarJugadorPorGPS(Usuario usuarioABuscar, Usuario usuarioOwner){
		val int rangoDeBusqueda = Integer.parseInt(usuarioABuscar.email)
		val sexoBuscado = usuarioABuscar.sexo
		val posicionBuscada = usuarioABuscar.posicion
		
		val candidatos = repoUsuario.getUsuariosEnElRangoDe(usuarioOwner, rangoDeBusqueda, sexoBuscado, posicionBuscada)
		
		val invitacion = new Notificacion()
		
		invitacion.partido = this
		invitacion.equipo = equipo1
		
		if(candidatos.size >= jugadoresTemporalesDelPartido.size){
			candidatos.forEach[candidato | candidato.agregarNotificacion(invitacion)
				println(candidato)
			]
		}else{
			throw new InsufficientCandidates("No se han encontrado suficientes jugadores con esos parametros de busqueda")
		}
		
	}
	
	def jugadoresTemporalesDelPartido(){
		val jugadores = jugadoresDelPartido
		jugadores.filter[jugador | jugador.esIntegranteDesconocido].toSet
		
		return jugadores
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

}
