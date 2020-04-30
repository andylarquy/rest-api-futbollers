package ar.edu.unsam.proyecto.apiRest

import ar.edu.unsam.proyecto.domain.Cancha
import ar.edu.unsam.proyecto.domain.Empresa
import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.exceptions.UserDoesntExist
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.RestHost
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.util.ArrayList
import java.util.Arrays
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestLlamadasApiRest {

	RepositorioUsuario repoUsuarios = RepositorioUsuario.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RestHost restHost = new RestHost
	
	
	LocalDateTime fechaDeReservaPartido1 = LocalDateTime.of(LocalDate.of(2020, 5, 27), LocalTime.of(20, 00))
	LocalDateTime fechaDeReservaPartido2 = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(17, 00))
	LocalDateTime fechaDeReservaPartido3 = LocalDateTime.of(LocalDate.of(2020, 4, 26), LocalTime.of(17, 30))
	LocalDateTime fechaDeReservaPartido4 = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(16, 00))
	
	Usuario sebaCapo = new Usuario() => [
		id = "U1"
		nombre = "sebaCapo"
		password = "mandarina"
		sexo = "M"
		posicion = "DC"
		foto = "https://i.imgur.com/gF6Q26G.jpg"
		email = "sebassdevita@gmail.com"
		lat = -34.5677486
		lon = -58.489429
	]

	Usuario nikoBostero = new Usuario() => [
		id = "U2"
		nombre = "nikoBostero"
		password = "mandarina"
		sexo = "M"
		posicion = "ED"
		foto = "https://i.imgur.com/a0UL9YQ.png"
		email = "niko.bostero.232@gmail.com"
		lat = -34.6344499
		lon = -58.3672355
	]

	Usuario andy = new Usuario() => [
		id = "U3"
		nombre = "andy"
		password = "mandarina"
		sexo = "M"
		posicion = "DFI"
		foto = "https://i.imgur.com/tBUGRSa.jpg"
		email = "andres27059934@gmail.com"
		lat = -34.6016244
		lon = -58.4420183
	]

	Usuario jugador1 = new Usuario() => [
		id = "U4"
		nombre = "Jugador 1"
		password = "mandarina"
		sexo = "M"
		posicion = "MC"
		foto = "https://i.imgur.com/DyYpkmS.jpg"
		email = "elmaildelnabo1@sarasa.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario jugador2 = new Usuario() => [
		id = "U5"
		nombre = "Jugador 2"
		password = "mandarina"
		sexo = "F"
		posicion = "EI"
		foto = "https://i.imgur.com/AofDmoH.jpg"
		email = "elmaildelnabo2@sarasa.com"
		lat = -34.5768884
		lon = -58.4904551
	]

	Usuario jugador3 = new Usuario() => [
		id = "U6"
		nombre = "Jugador 3"
		password = "mandarina"
		sexo = "M"
		posicion = "MC"
		foto = "https://i.imgur.com/mUPUwOS.jpg"
		email = "elmaildelnabo3@sarasa.com"
		lat = -34.6029831
		lon = -58.4408178
	]

	Usuario jugador4 = new Usuario() => [
		id = "U7"
		nombre = "Jugador 4"
		password = "mandarina"
		sexo = "F"
		posicion = "EI"
		foto = "https://i.imgur.com/kzeiAar.jpg"
		email = "elmaildelnabo4@sarasa.com"
		lat = -34.5768884
		lon = -58.4904551
	]

	Usuario warrenSanchez = new Usuario() => [
		id = "U8"
		nombre = "Warren Sanchez"
		password = "mandarina"
		sexo = "H"
		posicion = "Arquero"
		foto = "https://i.imgur.com/eKKFfS2.jpg"
		email = "elhalldelteatro@warren.com"
		lat = -34.6010406
		lon = -58.3830786
	]

	Usuario mastropiero = new Usuario() => [
		id = "U9"
		nombre = "Johan Sebastian Mastropiero"
		password = "mandarina"
		sexo = "H"
		posicion = "Delantero"
		foto = "https://i.imgur.com/TTaaxVH.jpg"
		email = "muchasGracias@DeNada.com"
		lat = -34.6010406
		lon = -58.3830786
	]
	
	Usuario usuarioNuevoValido = new Usuario() => [
		nombre = "Cosme fulanito"
		password = "mandarina"
		sexo = "H"
		posicion = "Defensor"
		foto = "https://i.imgur.com/ubhtccK.png"
		email = "cosme@fulanito.com"
		lat = -34.6010486
		lon = -58.3830746
	]
	
	Usuario usuarioNuevoInValido = new Usuario() => [
		nombre = "Le robo la cuenta a andres"
		password = "mandarina"
		sexo = "H"
		posicion = "Defensor"
		foto = "https://i.imgur.com/Rb7sxbv.jpg"
		email = "andres27059934@gmail.com"
		lat = -34.6010486
		lon = -58.3830746
	]

	Equipo equipazo = new Equipo() => [
		id = "E1"
		nombre = "El equipazo"
		owner = sebaCapo
		foto = "https://i.imgur.com/hccT1z9.jpg"
		integrantes = new ArrayList(Arrays.asList(sebaCapo, nikoBostero, andy, jugador1, jugador2))
	]

	Equipo equipoMalo = new Equipo() => [
		id = "E2"
		nombre = "El equipo malo"
		owner = andy
		foto = "https://i.imgur.com/RhqYpUg.jpg"
		integrantes = new ArrayList(Arrays.asList(jugador1, jugador2, jugador3, jugador4, andy))
	]

	Equipo equipoIncompleto = new Equipo() => [
		id = "E3"
		nombre = "Equipo incompleto"
		owner = nikoBostero
		foto = "https://i.imgur.com/lvR3nt3.jpg"
		integrantes = new ArrayList(Arrays.asList(sebaCapo, nikoBostero, andy))
	]

	Equipo equipoLesLuthier = new Equipo() => [
		id = "E4"
		nombre = "Yo que se, mira lo que me pedis"
		owner = mastropiero
		foto = "https://i.redd.it/kvq6bvmcask31.jpg"
		integrantes = new ArrayList(Arrays.asList(mastropiero, warrenSanchez, andy, jugador1, sebaCapo))
	]

	Cancha urquiza1 = new Cancha() => [
		id = "C1"
		nombre = "Cancha 1 Urquiza"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha urquiza2 = new Cancha() => [
		id = "C2"
		nombre = "Cancha 2 Urquiza"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop1 = new Cancha() => [
		id = "C3"
		nombre = "Cancha chica 1 Vic Lop"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop2 = new Cancha() => [
		id = "C4"
		nombre = "Cancha chica 2 Vic Lop"
		cesped = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop3 = new Cancha() => [
		id = "C5"
		nombre = "Cancha grande Vic Lop"
		cesped = "cemento"
		cantidadJugadores = 14
	]

	Cancha argen1 = new Cancha() => [
		id = "C6"
		nombre = "Cancha Chica Argentinos"
		cesped = "cemento"
		cantidadJugadores = 8
	]

	Cancha argen2 = new Cancha() => [
		id = "C7"
		nombre = "Cancha Grande Argentinos"
		cesped = "cemento"
		cantidadJugadores = 12
	]

	Empresa empresaUrquiza = new Empresa => [
		id = "E1"
		nombre = "Aguante uqz"
		lat = -34.5748777
		lon = -58.4903939
		canchas = new ArrayList(Arrays.asList(urquiza1, urquiza2))
		nombreDuenio = "Tito Bara"
		email = "aguanteUqz@vieja.com"
		direccion = "Roosevelt 5110"
		foto = "https://lh5.googleusercontent.com/p/AF1QipPF3MOS4J-Ou0mvOreYT8l3sIfHQu8_i1pQFbqI=w408-h509-k-no"
	]

	Empresa empresaVicenteLopez = new Empresa => [
		id = "E2"
		nombre = "Queda en la loma del orto"
		lat = -34.5141931
		lon = -58.5315329
		canchas = new ArrayList(Arrays.asList(vicLop1, vicLop2, vicLop3))
		nombreDuenio = "Jorge"
		email = "miraSiVaATenerMail@dePedoTieneAgua.com"
		direccion = "Mitre 3847"
		foto = "https://i.imgur.com/0R5wqI5.jpg"
	]

	Empresa empresaArgentinos = new Empresa => [
		id = "E3"
		nombre = "Argentinos :)"
		lat = -34.6078057
		lon = -58.4763221
		canchas = new ArrayList(Arrays.asList(argen1, argen2))
		nombreDuenio = "No se mi nombre"
		email = "niIdea@noSe.com"
		direccion = "Sarasa 123"
	]

	Partido partido1 = new Partido() => [
		id = "P1"
		owner = sebaCapo
		equipo1 = equipazo
		equipo2 = equipoMalo
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 5, 27), LocalTime.of(20, 00))
	]

	Partido partido2 = new Partido() => [
		id = "P2"
		owner = andy
		equipo1 = equipazo
		equipo2 = equipoIncompleto
		empresa = empresaVicenteLopez
		canchaReservada = vicLop2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(17, 00))
	]

	Partido partido3 = new Partido() => [
		id = "P3"
		owner = andy
		equipo1 = equipoMalo
		equipo2 = equipoLesLuthier
		empresa = empresaUrquiza
		canchaReservada = urquiza2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 26), LocalTime.of(17, 30))
	]

	Partido partido4 = new Partido() => [
		id = "P4"
		owner = sebaCapo
		equipo1 = equipoIncompleto
		equipo2 = equipazo
		empresa = empresaUrquiza
		canchaReservada = urquiza1
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(16, 00))
	]





	@Before
	def void init() {

		repoUsuarios.create(sebaCapo)
		repoUsuarios.create(nikoBostero)
		repoUsuarios.create(andy)
		repoUsuarios.create(jugador1)
		repoUsuarios.create(jugador2)
		repoUsuarios.create(jugador3)
		repoUsuarios.create(jugador4)
		repoUsuarios.create(warrenSanchez)
		repoUsuarios.create(mastropiero)

		repoPartido.create(partido1)
		repoPartido.create(partido2)
		repoPartido.create(partido3)
		repoPartido.create(partido4)

		repoEquipo.create(equipazo)
		repoEquipo.create(equipoMalo)
		repoEquipo.create(equipoIncompleto)
		repoEquipo.create(equipoLesLuthier)

	}





	@After
	def void after() {
		repoUsuarios.reset()
		repoEquipo.reset()
		repoPartido.reset
	}
	
	
	
	
	
	
	
	// <<<< TEST - LOGUEAR USUARIOS >>>>
	@Test
	def void loginSebaCapo() {
		Assert.assertEquals(sebaCapo, restHost.loguearUsuario("sebassdevita@gmail.com", "mandarina"))
	}
	
	@Test
	def void loginNikoBostero() {
		Assert.assertEquals(nikoBostero, restHost.loguearUsuario("niko.bostero.232@gmail.com", "mandarina"))
	}
	
	@Test
	def void loginAndy() {
		Assert.assertEquals(andy, restHost.loguearUsuario("andres27059934@gmail.com","mandarina"))
	}
	
	@Test
	def void loginWarrenSanchez() {
		Assert.assertEquals(warrenSanchez, restHost.loguearUsuario("elhalldelteatro@warren.com","mandarina"))
	}
	
	@Test
	def void loginMastropiero() {
		Assert.assertEquals(mastropiero, restHost.loguearUsuario("muchasGracias@DeNada.com","mandarina"))
	}
	
	@Test(expected = IncorrectCredentials)
	def void loginConCredencialesInvalidasSebaCapo() {
		restHost.loguearUsuario("esteMailEsIncorrecto@gmail.com", "mandarina")
	}
	
	@Test(expected = IncorrectCredentials)
	def void loginConCredencialesInvalidasAndy() {
		restHost.loguearUsuario("esteMailEsIncorrecto@gmail.com", "mandarina")
	}
	
	@Test(expected = IncorrectCredentials)
	def void loginConCredencialesInvalidasNikoBostero() {
		restHost.loguearUsuario("niko.bostero.232@gmail.com", "contraseña incorrecta")
	}
	
	@Test(expected = IncorrectCredentials)
	def void loginConCredencialesInvalidasMastropiero() {
		restHost.loguearUsuario("muchasGracias@DeNada.com", "contraseña incorrecta")
	}
	// <<<</ TEST - LOGUEAR USUARIOS >>>>







	// <<<< TEST - SIGNUP USUARIOS >>>>
	@Test
	def void signUpUsuarioValido() {
		restHost.signUpUsuario(usuarioNuevoValido)
		Assert.assertEquals(#[sebaCapo, nikoBostero, andy, jugador1, jugador2, jugador3, jugador4, warrenSanchez, mastropiero, usuarioNuevoValido], repoUsuarios.coleccion)
	}
	
	@Test(expected = IncorrectCredentials)
	def void signUpUsuarioMailInValido() {
		restHost.signUpUsuario(usuarioNuevoInValido)
	}

	// <<<</ TEST - SIGNUP USUARIOS >>>>








	// <<<< TEST - EQUIPOS DEL USUARIO >>>>
	@Test
	def void getEquiposDeSebaCapo() {
		Assert.assertEquals(#[equipazo, equipoIncompleto,  equipoLesLuthier],  restHost.getEquiposDelUsuario("U1"))
	}
	
	@Test
	def void getEquiposDeNikoBostero() {
		Assert.assertEquals(#[equipazo, equipoIncompleto],  restHost.getEquiposDelUsuario("U2"))
	}
	
	@Test
	def void getEquiposDeAndy() {
		Assert.assertEquals(#[equipazo, equipoMalo, equipoIncompleto,  equipoLesLuthier],  restHost.getEquiposDelUsuario("U3"))
	}
	
	@Test
	def void getEquiposDeMastropiero() {
		Assert.assertEquals(#[equipoLesLuthier],  restHost.getEquiposDelUsuario("U9"))
	}
	
	@Test(expected = UserDoesntExist)
	def void getEquiposUsuarioErroneo1() {
		restHost.getEquiposDelUsuario("U42")
	}
	
	@Test(expected = UserDoesntExist)
	def void getEquiposUsuarioErroneo2() {
		restHost.getEquiposDelUsuario("IdSuperErroneo")
	}
	// <<<</ TEST - EQUIPOS DEL USUARIO >>>>









	// <<<< TEST - PARTIDOS DEL USUARIO >>>>
	@Test
	def void getPartidosDeSebaCapo() {
		Assert.assertEquals(#[partido1, partido2, partido3, partido4],  restHost.getPartidosDelUsuario("U1"))
	}
	
	@Test
	def void getPartidosDeNikoBostero() {
		Assert.assertEquals(#[partido1, partido2, partido4],  restHost.getPartidosDelUsuario("U2"))
	}
	
	@Test
	def void getPartidosDeAndy() {
		Assert.assertEquals(#[partido1, partido2, partido3, partido4],  restHost.getPartidosDelUsuario("U3"))
	}
	
	@Test
	def void getPartidosDeMastropiero() {
		Assert.assertEquals(#[partido3],  restHost.getPartidosDelUsuario("U9"))
	}
	
	@Test(expected = UserDoesntExist)
	def void getPartidosUsuarioErroneo1() {
		restHost.getPartidosDelUsuario("U42")
	}
	
	@Test(expected = UserDoesntExist)
	def void getPartidosUsuarioErroneo2() {
		restHost.getPartidosDelUsuario("IdSuperErroneo")
	}
	// <<<</ TEST - PARTIDOS DEL USUARIO >>>>

}
