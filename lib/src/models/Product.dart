import 'dart:convert';

ProductModel productoModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productoModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {

    String id;
    String title;
    double value;
    bool available;
    String urlPicture;

    ProductModel({
        this.id,
        this.title = '',
        this.value  = 0.0,
        this.available = true,
        this.urlPicture,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        id         : json["id"],
        title     : json["title"],
        value      : json["value"],
        available : json["available"],
        urlPicture    : json["url_picture"],
    );

    Map<String, dynamic> toJson() => {
        "id"         : id,
        "title"     : title,
        "value"      : value,
        "available" : available,
        "url_picture"    : urlPicture,
    };
}
