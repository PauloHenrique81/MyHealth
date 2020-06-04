import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeProfissional extends StatefulWidget {
  final Profissional profissional;
  final User user;
  EdicaoDeProfissional({this.user, this.profissional});

  @override
  _EdicaoDeProfissionalState createState() => _EdicaoDeProfissionalState();
}

class _EdicaoDeProfissionalState extends State<EdicaoDeProfissional> {
  Profissional _profissionalEdicao;
  bool _userEdited = false;
  bool _novoProfissional = false;

  String profissao = "";

    var maskFormatterTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  var profissionais = [
    "Médico",
    "Fisioterapeuta",
    "Psicólogo",
    "Nutricionista",
    "Dentista"
  ];
  final _formKey = GlobalKey<FormState>();

  P_Profissional conectionDB = new P_Profissional();

  final _profissaoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _identificacaoController = TextEditingController();
  final _localDeAtendimentoController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.profissional == null) {
      _profissionalEdicao = Profissional();
      _novoProfissional = true;
    } else {
      _profissionalEdicao = widget.profissional;

      _profissaoController.text = _profissionalEdicao.profissao;
      _nomeController.text = _profissionalEdicao.nome;
      _especialidadeController.text = _profissionalEdicao.especialidade;
      _identificacaoController.text = _profissionalEdicao.identificacao;
      _localDeAtendimentoController.text =
          _profissionalEdicao.localDeAtendimento;
      _telefoneController.text = _profissionalEdicao.telefone;

      profissao = _profissionalEdicao.profissao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(_profissionalEdicao.nome ?? "Novo Profissional"),
            centerTitle: true,
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            overlayColor: Colors.black87,
            animatedIconTheme: IconThemeData.fallback(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.save),
                backgroundColor: Colors.deepPurple,
                label: "Salvar",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    if (_novoProfissional == true) {
                      await conectionDB.cadastraProfissional(
                          widget.user.uid,
                          _profissaoController.text,
                          _nomeController.text,
                          _localDeAtendimentoController.text,
                          especialidade: _especialidadeController.text,
                          identificacao: _identificacaoController.text,
                          telefone: _telefoneController.text,
                          tipoUser: "Nao");
                    } else {
                      await conectionDB.atualizarProfissional(
                          widget.user.uid,
                          _profissionalEdicao.idProfissional,
                          _nomeController.text,
                          _localDeAtendimentoController.text,
                          _profissaoController.text,
                          especialidade: _especialidadeController.text,
                          identificacao: _identificacaoController.text,
                          telefone: _telefoneController.text);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
              SpeedDialChild(
                  child: Icon(Icons.cancel),
                  backgroundColor: Colors.red,
                  label: "Excluir",
                  onTap: () {
                    if (!_novoProfissional) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Excluir Profissional ?"),
                              content: Text(
                                  "As informações deste Profissional, serão excluidas permanentemente"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Sim"),
                                  onPressed: () {
                                    conectionDB.excluirProfissional(
                                        _profissionalEdicao.idProfissional,
                                        widget.user.uid);
                                    Navigator.pushReplacementNamed(
                                        context, 'ListagemDeProfissionais',
                                        arguments: widget.user);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  })
            ],
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Profissão: * ", style:TextStyle( color: Colors.black)),
                        Expanded(
                          child: DropdownButton(
                            hint: Text(profissao, style:TextStyle( color: Colors.black)),
                            items:
                                profissionais.map((String profissaoEscolhida) {
                              return DropdownMenuItem<String>(
                                value: profissaoEscolhida,
                                child: Text(profissaoEscolhida),
                              );
                            }).toList(),
                            onChanged: (text) {
                              _userEdited = true;
                              _profissionalEdicao.profissao = text;
                              _profissaoController.text = text;

                              setState(() {
                                profissao = text;
                              });
                            },
                            isExpanded: true,
                          ),
                        )
                      ],
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: _especialidadeController,
                      decoration: InputDecoration(labelText: "Especialidade:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _profissionalEdicao.especialidade = text;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: "Nome: *"),
                      validator: (val) => val.isEmpty ? 'Digite o Nome' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _profissionalEdicao.nome = text;
                      },
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _identificacaoController,
                        decoration:
                            InputDecoration(labelText: "Identificação: *"),
                        validator: (val) => val.isEmpty ? 'Digite o codigo de identificação' : null,
                        onChanged: (text) {
                          _userEdited = true;
                          _profissionalEdicao.identificacao = text;
                        }),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _localDeAtendimentoController,
                        decoration:
                            InputDecoration(labelText: "Local de atendimento:"),
                        onChanged: (text) {
                          _userEdited = true;
                          _profissionalEdicao.localDeAtendimento = text;
                        }),
                    TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _telefoneController,
                        inputFormatters: [maskFormatterTelefone],
                        decoration: InputDecoration(labelText: "Telefone:"),
                        onChanged: (text) {
                          _userEdited = true;
                          _profissionalEdicao.telefone = text;
                        })
                  ],
                ),
              )),
        ));
  }

  Future<bool> _requestPop(BuildContext context) {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, 'ListagemDeProfissionais',
                        arguments: widget.user);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
