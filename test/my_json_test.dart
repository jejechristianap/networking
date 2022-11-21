import 'package:flutter_test/flutter_test.dart';
import 'package:networking/networking.dart';

void main() {
  group("Test parsing complex json", () {
    Map<String, dynamic> json = {
      "sellers": [
        {
          "id": "DSAD4TF",
          "items": [
            {
              "sellerProductId": "d5t5f4",
              "orderedQuantity": 123,
              "stockQuantity": 123,
              "price": 100000,
              "imageUrl": "https://xnasdf.com",
              "productName": "Semangka Inul"
            }
          ],
          "deliveryMov": {
            "price": 123,
            "mov": 100000,
          },
          "availableShippingOptions": [
            {
              "option": "DELIVERY",
              "slaString": "",
              "info": "",
            }
          ],
          "name": null,
          "address": ""
        }
      ],
      "availablePaymentMethods": ["ONLINE"]
    };
    MyJson myJson = MyJson(jsonData: json);
    MyJson seller = myJson.get("sellers").listDataValue().first.jsonValue();
    MyData paymentMethod =
        myJson.get("availablePaymentMethods").listDataValue().first;

    test("Test get valid field", () {
      expect(seller.get("id").stringValue(), "DSAD4TF");
      expect(paymentMethod.stringValue(), "ONLINE");
      expect(
        seller.get("deliveryMov").jsonValue().get("mov").doubleValue(),
        100000,
      );
      expect(
        seller.get("deliveryMov").jsonValue().get("price").intValue(),
        123,
      );
    });

    test("Test get invalid field", () {
      expect(seller.get("sellerName").stringValue(), "");
      expect(myJson.get("availablePaymentMethods").listDataValue().length, 1);
      expect(myJson.get("sellers").listDataValue().length, 1);
      expect(
        myJson.get("deliveryMovie").jsonValue().get("price").intValue(),
        0,
      );
    });

    test("Test null field", () {
      expect(seller.get("name").stringValue(), "");
      expect(seller.get("name").optStringValue(), isNull);
    });
  });
}
