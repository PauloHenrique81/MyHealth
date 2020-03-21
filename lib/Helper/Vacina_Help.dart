class Vacina_Help {
  Vacina crianca;
  Vacina adolescente;
  Vacina adulto;
  Vacina gestante;
  Vacina idoso;

  List<VacinaAux> vacinas = new List<VacinaAux>();

  Vacina_Help() {
    crianca = populaCrianca();
    adolescente = populaAdolescente();
    adulto = populaCrianca();
    idoso = populaIdoso();
    gestante = populaGestante();
    populaVacinaAux();
  }

  void populaVacinaAux() {
    var crianca =
        new VacinaAux("Criança", "Entre 0 e 10 anos", "Assets/bebe.jpg");
    var adolescente = new VacinaAux(
        "Adolescente", "Entre 11 e 19 anos", "Assets/adolescente.jpg");
    var adulto =
        new VacinaAux("Adulto", "Entre 20 e 59 anos", "Assets/adulto.jpg");
    var idoso = new VacinaAux("Idoso", "60 + anos", "Assets/idoso.jpg");
    var gestante =
        new VacinaAux("Gestante", "Período gestacional", "Assets/gestante.jpg");

    vacinas.add(crianca);
    vacinas.add(adolescente);
    vacinas.add(adulto);
    vacinas.add(idoso);
    vacinas.add(gestante);
  }

  Vacina populaGestante() {
    var v42 = new TiposDeVacinas(
        "v42",
        "Hepatite B",
        "Previne a hepatite do tipo B",
        "3 doses, de acordo com a situação vacinal");
    var v43 = new TiposDeVacinas("v43", "Dupla adulto (dT)",
        "Previne difteria e tétano", "Reforço a cada 10 anos");
    var v44 = new TiposDeVacinas(
        "v44",
        "dTpa  (Tríplice bacteriana acelular do tipo adulto) ",
        "(previne difteria, tétano e coqueluche",
        "Uma dose a cada gestação a partir da 20ª semana de gestação ou no puerpério (até 45 dias após o parto).");
    var v45 = new TiposDeVacinas("v45", "Influenza",
        "Contra os vírus que causam a grip", "Uma dose (anual)");

    var listaVacinaGestante = new List<TiposDeVacinas>();

    listaVacinaGestante.add(v42);
    listaVacinaGestante.add(v43);
    listaVacinaGestante.add(v44);
    listaVacinaGestante.add(v45);

    return new Vacina(
        nome: "Gestante",
        idade: "Período gestacional",
        listaVacinas: listaVacinaGestante);
  }

  Vacina populaIdoso() {
    var v37 = new TiposDeVacinas(
        "v37",
        "Hepatite B",
        "Previne a hepatite do tipo B",
        "3 doses, de acordo com a situação vacinal");
    var v38 = new TiposDeVacinas(
        "v38",
        "Febre Amarela",
        "Previne a febre amarela",
        "1 dose (a depender da situação vacinal anterior)");
    var v39 = new TiposDeVacinas("v39", "Dupla adulto (dT)",
        "Previne difteria e tétano", "Reforço a cada 10 anos");
    var v40 = new TiposDeVacinas(
        "v40",
        "Pneumocócica  23 Valente",
        "previne pneumonia, otite, meningite e outras doenças causadas pelo Pneumococo",
        "1 dose (Está indicada para população indígena e grupos-alvo específicos)");

    var v41 = new TiposDeVacinas("v41", "Influenza",
        "Contra os vírus que causam a grip", "Uma dose (anual)");

    var listaVacinaIdoso = new List<TiposDeVacinas>();

    listaVacinaIdoso.add(v37);
    listaVacinaIdoso.add(v38);
    listaVacinaIdoso.add(v39);
    listaVacinaIdoso.add(v40);
    listaVacinaIdoso.add(v41);

    return new Vacina(
        nome: "Idoso", idade: "60 + anos", listaVacinas: listaVacinaIdoso);
  }

  Vacina populaAdulto() {
    var v32 = new TiposDeVacinas(
        "v32",
        "Hepatite B",
        "Previne a hepatite do tipo B",
        "3 doses, de acordo com a situação vacinal");
    var v33 = new TiposDeVacinas(
        "v33",
        "Febre Amarela",
        "Previne a febre amarela",
        "1 dose (a depender da situação vacinal anterior)");
    var v34 = new TiposDeVacinas(
        "v34",
        "Tríplice viral",
        "previne sarampo, caxumba e rubéola",
        "2 doses (de acordo com a situação vacinal anterior)");
    var v35 = new TiposDeVacinas("v35", "Dupla adulto (dT)",
        "Previne difteria e tétano", "Reforço a cada 10 anos");
    var v36 = new TiposDeVacinas(
        "v36",
        "Pneumocócica 23 Valente",
        "Previne pneumonia, otite, meningite e outras doenças causadas pelo Pneumococo",
        "1 dose (Está indicada para população indígena e grupos-alvo específicos)");

    var listaVacinaAdulto = new List<TiposDeVacinas>();

    listaVacinaAdulto.add(v32);
    listaVacinaAdulto.add(v33);
    listaVacinaAdulto.add(v34);
    listaVacinaAdulto.add(v35);
    listaVacinaAdulto.add(v36);

    return new Vacina(
        nome: "Adulto",
        idade: "Entre 20 e 59 anos",
        listaVacinas: listaVacinaAdulto);
  }

  Vacina populaAdolescente() {
    var v25 = TiposDeVacinas(
        "v25",
        "HPV",
        "Previne o papiloma, virús humano que causa câncere e verrugas genitais,",
        "Duas doses com seis meses de intervalo");
    var v26 = TiposDeVacinas(
        "v26",
        "Meninqocócica C",
        "Doença invasiva causada por Neisseria meningitidis do sorogrupo CDose ",
        "Única ou");
    var v27 = TiposDeVacinas(
        "v27",
        "Hepatite B",
        "Previne a hepatite do tipo B",
        "3 doses, de acordo com a situação vacinal");
    var v28 = TiposDeVacinas("v28", "Febre Amarela", "Previne a febre amarela",
        "1 dose (a depender da situação vacinal anterior)");
    var v29 = TiposDeVacinas("v29", "Dupla Adulto", "Previne difteria e tétano",
        "Reforço a cada 10 anos");
    var v30 = TiposDeVacinas(
        "v30",
        "Tríplice viral",
        "Previne sarampo, caxumba e rubéola",
        "2 doses (de acordo com a situação vacinal anterior)");
    var v31 = TiposDeVacinas(
        "v31",
        "Pneumocócica 23 Valente",
        "Previne pneumonia, otite, meningite e outras doenças causadas pelo Pneumococo",
        " 1 dose (a depender da situação vacinal anterior)");
    var listaVacinaAdolescente = new List<TiposDeVacinas>();

    listaVacinaAdolescente.add(v25);
    listaVacinaAdolescente.add(v26);
    listaVacinaAdolescente.add(v27);
    listaVacinaAdolescente.add(v28);
    listaVacinaAdolescente.add(v29);
    listaVacinaAdolescente.add(v30);
    listaVacinaAdolescente.add(v31);

    return new Vacina(
        nome: "Adolescente",
        idade: "Entre 11 e 19 anos",
        listaVacinas: listaVacinaAdolescente);
  }

  Vacina populaCrianca() {
    var v1 = new TiposDeVacinas(
        "v1",
        "BCG(Bacilo Calmette-Guerin)",
        "Previne as formas graves de turbeculose, principalmente miliare meningea.",
        "Dose única");
    var v2 = new TiposDeVacinas(
        "v2", "Hepatite B", "Previne a hepatite do tipo B", "Dose única");
    var v3 = new TiposDeVacinas(
        "v3",
        "Pentavalente (DTP/HB/Hib)",
        "Previne diferia, tétano, coqueluche, hepatite B e meningite e infecções por HiB",
        "1º dose");
    var v4 = new TiposDeVacinas("v4", "VIP (Poliomielite inativada)",
        "Previne Poliomielite ou paralisia infantil", "1º dose");
    var v5 = new TiposDeVacinas(
        "v5",
        "Pneumocócica 10V",
        "Previne pneumonia, otite, meningite e outras doenças causadas pelo Pneumococo",
        "1º dose");
    var v6 = new TiposDeVacinas("v6", "Vacina rotavírus humano G1P1",
        "Previne diarreia por rotavírus", "1º dose");
    var v7 = new TiposDeVacinas("v7", "Meninqocócica C conjugada",
        "Previne a doença meningocócica C", "1º dose");
    var v8 = new TiposDeVacinas(
        "v8",
        "Pentavalente (DTP/HB/Hib)",
        "Previne diferia, tétano, coqueluche, hepatite B e meningite e infecções por HiB",
        "2º dose");
    var v9 = new TiposDeVacinas("v9", "VIP (Poliomielite inativada)",
        "Previne Poliomielite ou paralisia infantil", "2º dose");
    var v10 = new TiposDeVacinas(
        "v10",
        "Pneumocócica 10V",
        "Previne pneumonia, otite, meningite e outras doenças causadas pelo Pneumococo",
        "2º dose");
    var v11 = new TiposDeVacinas("v11", "Vacina rotavírus humano G1P1",
        "Previne diarreia por rotavírus", "2º dose");
    var v12 = new TiposDeVacinas("v12", "Meninqocócica C conjugada",
        "Previne a doença meningocócica C", "2º dose");
    var v13 = new TiposDeVacinas(
        "v13",
        "Pentavalente (DTP/HB/Hib)",
        "Previne diferia, tétano, coqueluche, hepatite B e meningite e infecções por HiB",
        "3º dose");
    var v14 = new TiposDeVacinas("v14", "VIP (Poliomielite inativada)",
        "Previne Poliomielite ou paralisia infantil", "3º dose");
    var v15 = new TiposDeVacinas(
        "v15", "Febre amarela", "Previne a febre amarela", "Uma dose");
    var v16 = new TiposDeVacinas(
        "v16",
        "Pneumocócica 10 Valente",
        "Previne pneumonia, otite, meningite e outras doenças causadas pelo Pneumococo",
        "Reforço");
    var v17 = new TiposDeVacinas("v17", "Tríplice Viral",
        "Previne sarampo, caxumba e rubéola", "1º dose");
    var v18 = new TiposDeVacinas(
        "v18", "Hepatite A", "Previne a hepatite do tipo A", "Dose única");
    var v19 = new TiposDeVacinas("v19", "Poliomielite oral VOP",
        "Previne poliomielite ou parasita infantil", "1º reforço");
    var v20 = new TiposDeVacinas(
        "v20", "DTP", "Difteria, tétano e coqueluche", "1º reforço");
    var v21 = new TiposDeVacinas(
        "v21",
        "Tetra viral ou triplice viral + varicela",
        "Previne sarampo, rubéola, caxumba e varicela/catapora",
        "Uma dose");
    var v22 = new TiposDeVacinas(
        "v22", "DTP", "Difteria, tétano e coqueluche", "2º reforço");
    var v23 = new TiposDeVacinas("v23", "Poliomielite oral VOP",
        "Previne poliomielite ou parasita infantil", "2º reforço");
    var v24 = new TiposDeVacinas(
        "v24", "Varicela atenuada", "Previne varicela/catapora", "Dose única");

    var listaVacinaCrianca = new List<TiposDeVacinas>();
    listaVacinaCrianca.add(v1);
    listaVacinaCrianca.add(v2);
    listaVacinaCrianca.add(v3);
    listaVacinaCrianca.add(v4);
    listaVacinaCrianca.add(v5);
    listaVacinaCrianca.add(v6);
    listaVacinaCrianca.add(v7);
    listaVacinaCrianca.add(v8);
    listaVacinaCrianca.add(v9);
    listaVacinaCrianca.add(v10);
    listaVacinaCrianca.add(v11);
    listaVacinaCrianca.add(v12);
    listaVacinaCrianca.add(v13);
    listaVacinaCrianca.add(v14);
    listaVacinaCrianca.add(v15);
    listaVacinaCrianca.add(v16);
    listaVacinaCrianca.add(v17);
    listaVacinaCrianca.add(v18);
    listaVacinaCrianca.add(v19);
    listaVacinaCrianca.add(v20);
    listaVacinaCrianca.add(v21);
    listaVacinaCrianca.add(v22);
    listaVacinaCrianca.add(v23);
    listaVacinaCrianca.add(v24);

    return new Vacina(
        nome: "Criança",
        idade: "Entre 0 e 10 anos",
        listaVacinas: listaVacinaCrianca);
  }
}

class Vacina {
  String nome;
  String idade;
  List<TiposDeVacinas> listaVacinas = List<TiposDeVacinas>();

  Vacina({this.nome, this.idade, this.listaVacinas});
}

class TiposDeVacinas {
  String codigo;
  String tipo;
  String descricao;
  String doses;
  bool status = false;
  String uid;
  String data;

  TiposDeVacinas(this.codigo, this.tipo, this.descricao, this.doses,
      {this.status, uid, data});
}

class VacinaAux {
  String nome;
  String periodo;
  String img;

  VacinaAux(this.nome, this.periodo, this.img);
}
