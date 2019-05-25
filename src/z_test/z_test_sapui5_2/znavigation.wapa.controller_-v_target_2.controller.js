sap.ui.define(["sap/ui/core/mvc/Controller","sap/ui/core/routing/History"], function(Controller) {                                                                                                                                                             
	"use strict";                                                                                                                                                                                                                                                 
	return Controller.extend("znavigation.controller.V_Target_2", {                                                                                                                                                                                               
		/**                                                                                                                                                                                                                                                          
		 *@memberOf znavigation.controller.V_Target_1                                                                                                                                                                                                                
		 */                                                                                                                                                                                                                                                          
		GoOneScreenBack: function(Evt) {                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                               
			var oHistory = sap.ui.core.routing.History.getInstance();                                                                                                                                                                                                   
			var sPreviousHash = oHistory.getPreviousHash();                                                                                                                                                                                                             
			// Go one screen back if you find a Hash                                                                                                                                                                                                                    
			if (sPreviousHash !== undefined) {                                                                                                                                                                                                                          
				window.history.go(-1);                                                                                                                                                                                                                                     
			}                                                                                                                                                                                                                                                           
			// If you do not find a correct Hash, go to the Source screen using default router;                                                                                                                                                                         
			else {                                                                                                                                                                                                                                                      
				var oRouter = sap.ui.core.UIComponent.getRouterFor(this);                                                                                                                                                                                                  
				oRouter.navTo("", true);                                                                                                                                                                                                                                   
			}                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                            
	});                                                                                                                                                                                                                                                           
});                                                                                                                                                                                                                                                            