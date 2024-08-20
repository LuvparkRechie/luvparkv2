class BookingDatafields {
  static final List<String> values = [
    reservedId,
    plateNo,
    bookDate,
    vhType,
    dtIn,
  ];

  static const String reservedId = 'reserved_id';
  static const String plateNo = 'plate_no';
  static const String bookDate = 'book_date';

  static const String vhType = 'vehicle_type';
  static const String dtIn = 'dt_in';
}



//  Map<String, dynamic> submitParam = {
//       "client_id": parameters["areaData"]["client_id"],
//       "park_area_id": parameters["areaData"]["park_area_id"],
//       "vehicle_plate_no": selectedVh[0]["vehicle_plate_no"],
//       "vehicle_type_id": selectedVh[0]["vehicle_type_id"].toString(),
//       "dt_in": dateIn.toString().toString().split(".")[0],
//       "dt_out": dateOut.toString().split(".")[0],
//       "no_hours": numberOfhours,
//       "tran_type": "R",
//     };