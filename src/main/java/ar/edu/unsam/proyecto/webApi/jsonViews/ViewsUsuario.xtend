package ar.edu.unsam.proyecto.webApi.jsonViews

//CHEATSHEET

class ViewsUsuario{         

    static class IdView {}
    static class DefaultView extends IdView {}
	static class CredencialesView extends DefaultView {}
	static class PerfilView extends DefaultView {}
	static class UbicacionView extends DefaultView {}
}

/*
 * class ViewsItems{
	
	static class SimpleView {}
	static class DetallesView extends SimpleView {}
	
}
*/

 