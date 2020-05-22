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

import io.github.cdimascio.dotenv.Dotenv

class TestLlamadasApiRest {

	RepositorioUsuario repoUsuarios = RepositorioUsuario.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RestHost restHost = new RestHost
	
	Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load()
	
	Usuario sebaCapo = new Usuario() => [
		id = "U1"
		nombre = "sebaCapo"
		password = dotenv.get("PASSWORD")
		sexo = "M"
		posicion = "DC"
		foto = "https://i.imgur.com/gF6Q26G.jpg"
		email = dotenv.get("EMAIL_SEBA")
		lat = -34.5677486
		lon = -58.489429
	]

	Usuario nikoBostero = new Usuario() => [
		id = "U2"
		nombre = "nikoBostero"
		password = dotenv.get("PASSWORD")
		sexo = "M"
		posicion = "ED"
		foto = "https://i.imgur.com/a0UL9YQ.png"
		email = dotenv.get("EMAIL_NIKO")
		lat = -34.6344499
		lon = -58.3672355
	]

	Usuario andy = new Usuario() => [
		id = "U3"
		nombre = "andy"
		password = dotenv.get("PASSWORD")
		sexo = "M"
		posicion = "DFI"
		foto = "https://i.imgur.com/tBUGRSa.jpg"
		email = dotenv.get("EMAIL_ANDY")
		lat = -34.6016244
		lon = -58.4420183
	]

	Usuario jugador1 = new Usuario() => [
		id = "U4"
		nombre = "Jugador 1"
		password = dotenv.get("PASSWORD")
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
		password = dotenv.get("PASSWORD")
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
		password = dotenv.get("PASSWORD")
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
		password = dotenv.get("PASSWORD")
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
		password = dotenv.get("PASSWORD")
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
		password = dotenv.get("PASSWORD")
		sexo = "H"
		posicion = "Delantero"
		foto = "https://i.imgur.com/TTaaxVH.jpg"
		email = "muchasGracias@DeNada.com"
		lat = -34.6010406
		lon = -58.3830786
	]
	
	Usuario usuarioNuevoValido = new Usuario() => [
		nombre = "Cosme fulanito"
		password = dotenv.get("PASSWORD")
		sexo = "H"
		posicion = "Defensor"
		foto = "https://i.imgur.com/ubhtccK.png"
		email = "cosme@fulanito.com"
		lat = -34.6010486
		lon = -58.3830746
	]
	
	Usuario usuarioNuevoInValido = new Usuario() => [
		nombre = "Le robo la cuenta a andres"
		password = dotenv.get("PASSWORD")
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
	
	Equipo equipoNuevo1 = new Equipo() =>[
		nombre = "Equipo Nuevo 1"
		owner = andy
		foto = "https://i.redd.it/1qy5y3wkidx41.jpg"
		integrantes = new ArrayList(Arrays.asList(andy, nikoBostero, sebaCapo, jugador1, jugador2))
	]
	
	Equipo equipoNuevo2 = new Equipo() =>[
		nombre = "Equipo Nuevo 2"
		owner = sebaCapo
		foto = "https://i.redd.it/1qy5y3wkidx41.jpg"
		integrantes = new ArrayList(Arrays.asList(andy, nikoBostero, sebaCapo, jugador1, jugador2))
	]

	Cancha urquiza1 = new Cancha() => [
		id = "C1"
		foto = "https://i.imgur.com/jrziFQc.png"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
	]

	Cancha urquiza2 = new Cancha() => [
		id = "C2"
		foto = "https://i.imgur.com/iUBWJAL.jpg"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop1 = new Cancha() => [
		id = "C3"
		foto = "https://i.imgur.com/J29IXSA.png"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop2 = new Cancha() => [
		id = "C4"
		foto = "https://i.imgur.com/OO24aMM.jpg"
		setSuperficie = "sintetico"
		cantidadJugadores = 10
	]

	Cancha vicLop3 = new Cancha() => [
		id = "C5"
		foto = "https://i.imgur.com/k14oJiW.jpg"
		setSuperficie = "cemento"
		cantidadJugadores = 14
	]

	Cancha argen1 = new Cancha() => [
		id = "C6"
		foto = "https://i.imgur.com/1eIVVny.jpg"
		setSuperficie = "cemento"
		cantidadJugadores = 8
	]

	Cancha argen2 = new Cancha() => [
		id = "C7"
		foto = "https://i.imgur.com/2yZN1T5.jpg"
		setSuperficie = "cemento"
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
		foto = "https://i.imgur.com/uBq4qBV.jpg"
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
		foto = "https://i.imgur.com/9QfoGNr.png"
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
		foto = "https://i.imgur.com/RUOAmuX.png"
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
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 4, 24), LocalTime.of(16,00))
	]
	
	Partido partidoNuevo1 = new Partido() => [
		id = "P5"
		owner = andy
		equipo1 = equipoIncompleto
		equipo2 = equipazo
		empresa = empresaUrquiza
		canchaReservada = urquiza2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 5, 14), LocalTime.of(15, 00))
	]
	
	Partido partidoNuevo2 = new Partido() => [
		id = "P6"
		owner = jugador3
		equipo1 = equipoMalo
		equipo2 = equipazo
		empresa = empresaArgentinos
		canchaReservada = argen2
		fechaDeReserva = LocalDateTime.of(LocalDate.of(2020, 10, 18), LocalTime.of(14, 30))
	]






	@Before
	def void init() {

		//Es para suprimir el warning nomas
		empresaArgentinos = empresaArgentinos

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
		Assert.assertEquals(sebaCapo, restHost.loguearUsuario("sebassdevita@gmail.com", dotenv.get("PASSWORD")))
	}
	
	@Test
	def void loginNikoBostero() {
		Assert.assertEquals(nikoBostero, restHost.loguearUsuario("niko.bostero.232@gmail.com", dotenv.get("PASSWORD")))
	}
	
	@Test
	def void loginAndy() {
		Assert.assertEquals(andy, restHost.loguearUsuario("andres27059934@gmail.com",dotenv.get("PASSWORD")))
	}
	
	@Test
	def void loginWarrenSanchez() {
		Assert.assertEquals(warrenSanchez, restHost.loguearUsuario("elhalldelteatro@warren.com",dotenv.get("PASSWORD")))
	}
	
	@Test
	def void loginMastropiero() {
		Assert.assertEquals(mastropiero, restHost.loguearUsuario("muchasGracias@DeNada.com",dotenv.get("PASSWORD")))
	}
	
	@Test(expected = IncorrectCredentials)
	def void loginConCredencialesInvalidasSebaCapo() {
		restHost.loguearUsuario("esteMailEsIncorrecto@gmail.com", dotenv.get("PASSWORD"))
	}
	
	@Test(expected = IncorrectCredentials)
	def void loginConCredencialesInvalidasAndy() {
		restHost.loguearUsuario("esteMailEsIncorrecto@gmail.com", dotenv.get("PASSWORD"))
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
	
	// <<<< GET EQUIPOS DEL USUARIO >>>>
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
	// <<<</ GET EQUIPOS DEL USUARIO >>>>
	
	
	// <<<< CREAR NUEVO EQUIPO >>>>
	@Test
	def void crearNuevoEquipo1() {
		restHost.crearNuevoEquipo(equipoNuevo1)
		Assert.assertEquals(#[equipazo, equipoMalo, equipoIncompleto,  equipoLesLuthier, equipoNuevo1], repoEquipo.coleccion )
	}
	
	@Test
	def void crearNuevoEquipo2() {
		restHost.crearNuevoEquipo(equipoNuevo2)
		Assert.assertEquals(#[equipazo, equipoMalo, equipoIncompleto,  equipoLesLuthier, equipoNuevo2], repoEquipo.coleccion )
	}
	
	def void crearNuevoEquipoDosVecesFunciona() {
		restHost.crearNuevoEquipo(equipoNuevo1)
		restHost.crearNuevoEquipo(equipoNuevo1)
		Assert.assertEquals(#[equipazo, equipoMalo, equipoIncompleto,  equipoLesLuthier, equipoNuevo1, equipoNuevo1], repoEquipo.coleccion )
	}
	
	def void crearNuevoEquipoDosVecesLesAsignaIDsDistintos() {
		restHost.crearNuevoEquipo(equipoNuevo1)
		restHost.crearNuevoEquipo(equipoNuevo2)
		Assert.assertEquals(equipoNuevo1.id, "E5")
		Assert.assertEquals(equipoNuevo2.id, "E6")
	}
	
	// <<<</ CREAR NUEVO EQUIPO >>>>
	

	// <<<</ TEST - EQUIPOS DEL USUARIO >>>>







	// <<<< TEST - PARTIDOS DEL USUARIO >>>>
	
	// <<<< GET PARTIDOS DEL USUARIO >>>>
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
	// <<<</ GET PARTIDOS DEL USUARIO >>>>
	
	// <<<< CREAR NUEVO PARTIDO >>>>
	@Test
	def void crearNuevoPartido1() {
		restHost.crearNuevoPartido(partidoNuevo1)
		Assert.assertEquals(#[partido1, partido2, partido3,  partido4, partidoNuevo1], repoPartido.coleccion )
	}
	
	@Test
	def void crearNuevoPartido2() {
		restHost.crearNuevoPartido(partidoNuevo2)
		Assert.assertEquals(#[partido1, partido2, partido3,  partido4, partidoNuevo2], repoPartido.coleccion )
	}
	
	def void crearNuevoPartidoDosVecesFunciona() {
		restHost.crearNuevoPartido(partidoNuevo1)
		restHost.crearNuevoPartido(partidoNuevo1)
		Assert.assertEquals(#[partido1, partido2, partido3,  partido4, partidoNuevo1, partidoNuevo1], repoEquipo.coleccion )
	}
	
	def void crearNuevoPartidoDosVecesLesAsignaIDsDistintos() {
		restHost.crearNuevoPartido(partidoNuevo1)
		restHost.crearNuevoPartido(partidoNuevo2)
		Assert.assertEquals(partidoNuevo1.id, "P7")
		Assert.assertEquals(partidoNuevo2.id, "P8")
	}
	// <<<</ CREAR NUEVO PARTIDO >>>>
	
	// <<<</ TEST - PARTIDOS DEL USUARIO >>>>
	
	

}