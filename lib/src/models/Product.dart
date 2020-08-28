import 'dart:convert';

ProductModel productoModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productoModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {

    String id;
    String name;
    double price;
    bool available;
    String urlPicture;

    ProductModel({
        this.id,
        this.name = '',
        this.price  = 0.0,
        this.available = true,
        this.urlPicture,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        id         : json["_id"],
        name     : json["name"],
        price      : json["price"].toDouble(),
        available : json["available"],
        urlPicture    : json["url_picture"],
    );

    Map<String, dynamic> toJson() => {
        "id"         : id,
        "name"     : name,
        "price"      : price,
        "available" : available,
        "url_picture"    : urlPicture,
    };
}
