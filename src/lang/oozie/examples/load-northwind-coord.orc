 task `load-customer`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/customer.ptl";
   ) -> `load-northwind-coord`

 task `load-employee`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/employee.ptl";
   ) -> `load-northwind-coord`

 task `load-product`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/product.ptl";
   ) -> `load-northwind-coord`

 task `load-supplier`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/supplier.ptl";
   ) -> `load-northwind-coord`

 task `load-purchase-orders`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/purchase_orders.ptl";
   ) -> `load-northwind-coord`

 task `load-purchase-order-details`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/purchase_order_details.ptl";
   ) -> `load-northwind-coord`

 task `load-inventory-transactions`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/inventory_transactions.ptl";
   ) -> `load-northwind-coord`

 task `load-orders`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/orders.ptl";
   ) -> `load-northwind-coord`

 task `load-order-details`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = ".scripts/hivestg/order_details.ptl";
   ) -> `load-northwind-coord`

 builder
        .startWith(`load-customer`)
        .onError(kill)
        .then(`load-employee`)
        .onError(kill)
        .then(`load-product`)
        .onError(kill)
        .then(`load-supplier`)
        .onError(kill)
        .then(`load-purchase-orders`)
        .onError(kill)
        .then(`load-purchase-order-details`)
        .onError(kill)
        .then(`load-inventory-transactions`)
        .onError(kill)
        .then(`load-orders`)
        .onError(kill)
        .then(`load-order-details`)
        .kill(kill, "Action failed, error message[${wf:errorMessage(wf:lastErrorNode())}]")
        .end(end)
