package views.util
{
	import com.util.restriccionesXML;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.events.ListEvent;

	/**
 	 * @author davidc
 	 */
	public class FolderStructure extends Tree
	{
		
		private var filter_xml:XML;
		
		function FolderStructure():void{
			super();
			initializeComponent();			
		}
		
		private function initializeComponent():void{
			this.percentHeight = 100;
			this.percentWidth = 20;
			this.addEventListener(ListEvent.ITEM_CLICK, getClick);
			//this.setStyle("cornerRadius","8");
		}
		
		public function loadStructure(xml:XML):void{
			var structure_xml:XMLList = new XMLList(xml);
			this.labelField = "@label";
			this.dataProvider = structure_xml.item;
			this.setStyle('defaultLeafIcon', this.getStyle("folderOpenIcon"));
		}
		
		private function getClick(evt:ListEvent):void{
			//
			filter_xml = parentDocument.xmlrestricciones;	
			var item:Object = Tree(evt.currentTarget).selectedItem;
			
			var restrictions:restriccionesXML = new restriccionesXML;
			restrictions.setTipo(item.@type);		
			
			if(item.@type == "leaf")
				restrictions.setValor([item.@root,item.@label]);
			else
				restrictions.setValor(item.@label);
			
			var xmllis:XMLListCollection = new XMLListCollection();
			var xml:XMLList = restrictions.crearItem(1);
			var xmllist:XMLList = new XMLList(filter_xml.children());
			var size:int = xmllist.length();
			var towrite:Boolean = true
			
			for (var i:int=0; i < size; i++){
				if(xmllist[i].@id == xml.@id){
					towrite = false
					filter_xml.replace(i,xml);
				}
			}
			
			if(towrite)
				filter_xml.appendChild(xml);
			
			parentDocument.xmlrestricciones = filter_xml;
			parentDocument.requestData();
		}

	}	
}