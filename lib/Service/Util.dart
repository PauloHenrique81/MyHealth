class Util {
  static int verificaData(String data) {
    var aux = data.split('-');
    DateTime dateTime =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));

    var dateNow = DateTime.now();
    var newDate = new DateTime(dateNow.year, dateNow.month, dateNow.day);
    return newDate.compareTo(dateTime);
  }
 
  static bool verificaSeEmailFoiCadastrado(String email, List<String> listaDeEmails){
      
      for (var item in listaDeEmails) {
        if(item == email)
          return true;
      }

      return false;
  }


  static String _removeMascaraCpf(String cpf){
    String cpfSemMascara = "";

    for (var i = 0; i < cpf.length; i++) {
      if(cpf[i] != '.' && cpf[i] != '-')
        cpfSemMascara += cpf[i];
    }

    return cpfSemMascara;
  }


  static bool verificaCPF(String strCPF) {
    var soma;
    var resto;
    strCPF = _removeMascaraCpf(strCPF);
    soma = 0;
    if (strCPF == "00000000000" || strCPF == "11111111111" || strCPF == "22222222222" || strCPF == "33333333333" || strCPF == "44444444444" || strCPF == "55555555555") 
      return false;
    if (strCPF == "66666666666" || strCPF == "77777777777" || strCPF == "88888888888" || strCPF == "99999999999" || strCPF == "44444444444" || strCPF == "55555555555") 
      return false;

    for (int i=1; i<=9; i++){
      soma = soma + int.parse(strCPF.substring(i-1, i)) * (11 - i);
      resto = (soma * 10) % 11;
    } 
    
    if ((resto == 10) || (resto == 11))  resto = 0;
    if (resto != int.parse(strCPF.substring(9, 10)) ) return false;
    
    soma = 0;
    for (int i = 1; i <= 10; i++){
        soma = soma + int.parse(strCPF.substring(i-1, i)) * (12 - i);
        resto = (soma * 10) % 11;
    }
  
    if ((resto == 10) || (resto == 11))  resto = 0;
    if (resto != int.parse(strCPF.substring(10, 11) ) ) return false;
    return true;
  }


}


