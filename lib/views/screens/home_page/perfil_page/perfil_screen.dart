import 'package:encontraste/controllers/global_controller.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        UpperSection(),
        MiddleSection(),
      ],
    ));
  }
}

class MiddleSection extends StatelessWidget {
  const MiddleSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Today's activity"),
            subtitle: Text('31 tasks in 5 categories'),
            trailing: ClipOval(
              child: Container(
                  height: 40.0,
                  width: 40.0,
                  color: Colors.green.withOpacity(0.2),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    color: Colors.green,
                  )),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              height: 160.0,
              child: ListView(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ItemCard(Icons.favorite, 'Health', '2 tasks'),
                  ItemCard(Icons.person, 'Personal', '3 tasks'),
                  ItemCard(Icons.power, 'Power', '4 tasks'),
                  ItemCard(Icons.power, 'Power', '4 tasks'),
                  ItemCard(Icons.power, 'Power', '4 tasks'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final icon;
  final name;
  final tasks;
  const ItemCard(this.icon, this.name, this.tasks);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 160.0,
        width: 120.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.indigo[900],
              BereaColors.purple,
              BereaColors.purple
            ])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
              ),
              Spacer(),
              Text(
                name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                tasks,
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperSection extends StatelessWidget {
  const UpperSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalController state = Provider.of<GlobalController>(context);
    var cargando = state.myDataPersona.id;

    return cargando == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          NetworkImage(state.myDataPersona?.imagen ?? ""),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      '${state.myDataPersona.nombres.split(" ")[0]} ${state.myDataPersona.apellidos.split(" ")[0]}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      state.myDataPersona.idEquipo == "0OtwyNJ5VMlYrhjKWLjd"
                          ? "Equipo Celeste"
                          : state.myDataPersona.idEquipo ==
                                  "vuEV8viTnRUBe2bL4aGO"
                              ? "Equipo Naranja"
                              : "Sin Equipo",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: state.myDataPersona.idEquipo ==
                                "0OtwyNJ5VMlYrhjKWLjd"
                            ? Colors.lightBlue
                            : state.myDataPersona.idEquipo ==
                                    "vuEV8viTnRUBe2bL4aGO"
                                ? Colors.orange
                                : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        Colors.indigo[900],
                        Colors.indigo[900],
                        BereaColors.purple
                      ])),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 48.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          '54',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'created',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'tasks',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '38',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'tasks',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '27',
                          style: TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'Reached',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'goals',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
