class Util {
  static int verificaData(String data) {
    var aux = data.split('-');
    DateTime dateTime =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));

    var dateNow = DateTime.now();
    var newDate = new DateTime(dateNow.year, dateNow.month, dateNow.day);
    return newDate.compareTo(dateTime);
  }
}
