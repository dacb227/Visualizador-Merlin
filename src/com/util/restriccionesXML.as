package com.util{

	import mx.collections.XMLListCollection;
	
	public class restriccionesXML{
		
		private var columna:String;
		private var tipo:String;
		private var desde:String;
		private var hasta:String;
		private var valor:Object;
		private var item:String;
		private var id:String = "";
		private var cont:int = 0;
		
		public function crearItem(index:int):XMLList{
			cont++;
			item = "<item id=\""+index+"\">" + 
					"<column>"+columna+"</column>" + 
					"<type>"+tipo+"</type>";
			
			if(tipo=="rango"){
				//item +=	"<value sp=\""+"min"+"\">"+desde+"</value>" + 
				//		"<value sp=\""+"max"+"\">"+hasta+"</value>";
				item +=	"<value>"+desde+"</value>" + 
						"<value>"+hasta+"</value>";
			}else{
				//item += "<value sp=\""+""+"\">"+valor+"</value>"; 
				item += "<value id='"+id+"'>"+valor+"</value>";
						
			}

			item += "</item>"; 

			return new XMLList(item);
		}
		
		public function repetido(xml:XMLListCollection, nodoxml:XML):Boolean{
			var cont:int = 0;
			
			for(var i:int = 0; i < xml.length; i++){
				if(xml[i].column == nodoxml.column && xml[i].type == nodoxml.type){
					for(var j:int = 0; j < xml[i].value.length(); j++){
						if(xml[i].value[j] == nodoxml.value[j]){
							cont++
						}
					}
					if(cont >= nodoxml.value.length()){
						return true;
					}	
					cont = 0;
				}
			}
			return false;
		}
		
		public function cambiarPosicion(xml:XMLListCollection, origen:int, destino:int):XMLListCollection{
       		var tempxml:Object = xml.getItemAt(origen);
			xml.setItemAt(xml.getItemAt(destino),origen);
			xml.setItemAt(tempxml,destino);
			return xml;
       	}
			
		public function moverPosicion(xml:XMLListCollection, origen:int, destino:int):XMLListCollection{
       		var tempxml:Object = xml.getItemAt(origen);
			xml.removeItemAt(origen);
			xml.addItemAt(tempxml, destino);
			return xml;
       	}
		
		public function setColumna(columna:String):void{
			this.columna = columna;
		}
		
		public function setTipo(tipo:String):void{
			this.tipo = tipo;
		}
		
		public function setDesde(desde:String):void{
			this.desde = desde;
		}
		
		public function setHasta(hasta:String):void{
			this.hasta = hasta;
		}
		
		public function setValor(valor:Object):void{
			this.valor = valor;
		}
		
		public function setId(id:String):void{
			this.id = id;
		}
		
	}
}