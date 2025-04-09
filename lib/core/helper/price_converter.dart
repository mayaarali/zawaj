
import 'package:flutter/material.dart';


class PriceConverter {


  static double convertWithDiscount(BuildContext context, double price, double discount, String discountType) {

    if(discountType.toLowerCase() == 'flat') {
      price = price - discount;
    }else {
      price = price - ((discount / 100) * price);
    }
    return double.parse(price.toStringAsFixed(1)) ;
  }






  static double calculation(double discount, String type) {
    double calculatedAmount = 0;
    if(type.toString().toLowerCase() == 'flat') {
      calculatedAmount = discount ;
    }else  {
      calculatedAmount = (discount / 100) ;
    }
    return calculatedAmount;
  }

  }