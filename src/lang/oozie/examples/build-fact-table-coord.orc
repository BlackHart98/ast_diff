 task `fact-sales`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = "./scripts/hivewh/fact_sales.ptl";
   ) -> `build-fact-table-coord`

 task `fact-purchase-orders`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = "./scripts/hivewh/fact_purchase_orders.ptl";
   ) -> `build-fact-table-coord`

 task `fact-inventory-transactions`:
   HiveAction (
    jobTracker = "${jobTracker}"; 
    nameNode = "${nameNode}"; 
    script = "./scripts/hivewh/fact_inventory_transactions.ptl";
   ) -> `build-fact-table-coord`

 builder
        .startWith(`fact-sales`)
        .onError(kill)
        .then(`fact-purchase-orders`)
        .onError(kill)
        .then(`fact-inventory-transactions`)
