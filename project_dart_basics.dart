/*Project Title: Shopping Cart & Billing System
Stage 1 → Setup Products
Stage 2 → Display Products
Stage 3 → Add to Cart
Stage 4 → Bill Calculation
Stage 5 → Discount & GST
Stage 6 → Final Invoice
Stage 7 → Exception Handling
*/

//Stage 1 -> Setup Products 

import 'dart:io';
void main(){
  //Stage 1 -> Setup Products
  List<Map<String,dynamic>> products=[
    {"id":1,"name":"Apple","price":50, "stock":10},
    {"id":2,"name":"Milk","price":30, "stock":5},
    {"id":3,"name":"Bread","price":40, "stock":8},
    {"id":4,"name":"Eggs","price":80, "stock":12},
    {"id":5,"name":"Butter","price":120, "stock":6}
    ];

    //empty to cart
    List<Map<String,dynamic>> cart=[];

    //add to cart
    addToCart(products,cart);

    //check if cart is empty
    if(cart.isEmpty){
      print("Your cart is empty! Nothing to bill");
    }else{
      //print cart summary
      print("\nYour Cart: ");
      cart.forEach((item){
        print("${item['name']} x ${item['quantity']} = ₹${item['price'] * item['quantity']}");
    });

    //print final invoice
      printFinalInvoice(cart, products);
    }
}

//_____________________________________
//Stage 2-> Display all Products
//______________________________________

  void displayProducts(List<Map<String,dynamic>> products){
    print("================================");
    print("     WELCOME TO OUR SHOP       ");
    print("================================");
    print("ID   | Name    | price | Stock");
    print("--------------------------------");
    
    for(var product in products){
      print("${product['id']} | ${product['name']}      | ₹${product['price']}  | ${product['stock']}");
    }
    print("==============================");
  }
//___________________________________________
//Stage: 7 Safe Input Function
//___________________________________________
int getValidInput(String message){
  while(true){
    try{
      print(message);
      int value=int.parse(stdin.readLineSync()!);

      //check negative number
      if(value<0){
        print("Please enter a positive number!");
        continue; //go back to the start of while loop
      }
    return value; //valid input - return it
    }catch(e){
      print("Invalid input! Please enter a number only.");
    }
  }
}
  
//___________________________________________
//Stage 3-> Add to cart
//___________________________________________

    void addToCart(List<Map<String,dynamic>> products,
      List<Map<String,dynamic>> cart){

        displayProducts(products);

        int id=getValidInput("Enter Product ID to add to cart (0 to stop):");

        //keep adding until user enters 0
          while(id!=0){
            //find product by id
            var product=products.firstWhere(
              (p) => p["id"] == id,
              orElse: () => {},
            );
            /*NOTE:
            > .firstWhere() -> Returns the first item that matches the condition
            > Similar to .where() but returns only one item instead of a list
            
            > orElse: () => {}
              > This runs only if no product is found
              > orElse is a safety net — without it, Dart throws an error if item not found
              > () => {} returns an empty Map {} when nothing is found also used with .firstWhere() */
            
            //check if product exists
            if(product.isEmpty){
              print("Product not found! Please enter valid ID.");
            }else{
              //using getValidInput for quantity too
              int quantity=getValidInput("Enter quantity: ");

              //check 0 quantity
              if(quantity==0){
                print("Quantity cannot be 0!");
              }else if(quantity>product["stock"]){
                print("Only ${product['stock']} items available in stock!");
              }else{
                //check if product already in cart
                var cartItem=cart.firstWhere(
                  (c) => c["id"]==id,
                  orElse: () => {},
                );
                
                if(cartItem.isEmpty){
                  //add new item to cart
                  cart.add({
                    "id":product["id"],
                    "name":product["name"],
                    "price":product["price"],
                    "quantity":quantity,
                });
                }else{
                  //update quantity if already in cart
                  cartItem["quantity"]+=quantity;
                }
                
                //reduce stock
                product["stock"]-=quantity;
                print("${product['name']} added to cart!");
              }//else closes
            }//else closes
            id=getValidInput("Enter product ID to add to cart (click 0 to stop: )");
          } //while ends here
        }
  //_________________________________________________
  //Stage 4-> Bill calculation
  //_________________________________________________

  int calculateBill(List<Map<String,dynamic>> cart){
    print("\n===============================");
    print("           YOUR BILL         ");
    print("===============================");
    print("Item     | Qty  |  Price | Total");
    print("--------------------------------");

    int totalAmount=0;
    cart.forEach((item){
      int itemTotal=item["price"]*item["quantity"];
      totalAmount+=itemTotal;

      print("${item['name']}    | ${item['quantity']}    | ₹${item['price']}    | ₹$itemTotal");
    });
    print("--------------------------------------------");
    print("Total Amount     : ₹ $totalAmount");
    print("===========================================");
    return totalAmount;
  }

//________________________________________________
//Stage 5-> Discount & GST
//________________________________________________

  /*If totalAmount > 500  -> 10% discount
If totalAmount > 1000 -> 20% discount

GST = 18% on amount after discount
Final Amount = totalAmount - discount + GST */

void applyDiscountAndGST(int totalAmount){
print("\n======================================");
print("           DISCOUNT & GST      ");
print("======================================");

//calculate discount
double discount=0;
if(totalAmount>1000){
  discount=totalAmount*.20; //20% discount
  print("Discount(20%)    : -₹${discount.toStringAsFixed(2)}");
}else if(totalAmount>500){
  discount=totalAmount*0.10; //10% discount
  print("Discount (10%)   : -₹${discount.toStringAsFixed(2)}");
} else{
  print("Discount         : No discount available");
}

//amount after discount
double afterDiscount=totalAmount-discount;
print("After Discount   : ₹${afterDiscount.toStringAsFixed(2)}");

//calculate GST 18%
double gst=afterDiscount*0.18;
print("GST (18%)        : +${gst.toStringAsFixed(2)}");

//final amount
double finalAmount=afterDiscount+gst;
print("---------------------------------------");
print("Final Amount     : ₹${finalAmount.toStringAsFixed(2)}");
print("=======================================");
print("=======================================");
}

//________________________________________________
//Stage 6-> Final Invoice
//________________________________________________

void printFinalInvoice(List<Map<String,dynamic>> cart,
  List<Map<String,dynamic>> products) {

    //get current date and time
    DateTime now=DateTime.now();

    print("\n===========================================");
    print("         SHOPPING MART           ");
    print("===========================================");
    print("Date : ${now.day}/${now.month}/${now.year}");
    print("Time : ${now.hour}:${now.minute}:${now.second}");
    print("--------------------------------------");
    print("FINAL INVOICE");
    print("--------------------------------------");
    print("Item     | Qty    | Price      |  Total ");

    int totalAmount=0;
    cart.forEach((item){
      int itemTotal=item["price"]*item["quantity"];
      totalAmount+=itemTotal;
      print("${item['name']}    | ${item['quantity']}     |  ₹${item['price']}         | ₹$itemTotal");
    });
  print("----------------------------------------------");
  print("Subtotal         : ₹$totalAmount");

  //discount logic
  double discount=0;
if(totalAmount>1000){
  discount=totalAmount*.20; //20% discount
  print("Discount(20%)    : -₹${discount.toStringAsFixed(2)}");
}else if(totalAmount>500){
  discount=totalAmount*0.10; //10% discount
  print("Discount (10%)   : -₹${discount.toStringAsFixed(2)}");
} else{
  print("Discount         : No discount available");
}

//amount after discount
double afterDiscount=totalAmount-discount;
print("After Discount   : ₹${afterDiscount.toStringAsFixed(2)}");

//calculate GST 18%
double gst=afterDiscount*0.18;
print("GST (18%)        : +${gst.toStringAsFixed(2)}");

//final amount
double finalAmount=afterDiscount+gst;
print("---------------------------------------");
print("FINAL AMOUNT     : ₹${finalAmount.toStringAsFixed(2)}");
print("=========================================");
print("    Thank you for shopping with us!    ");
print("=========================================");
}