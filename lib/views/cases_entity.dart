import 'package:flutter/material.dart';

class CasesEntity extends StatelessWidget {
  final String caseEntity;
  final String cases;
  final String additionalCase;
  final Color caseColor;
  final bool isVisible;

  const CasesEntity(this.caseEntity, this.cases, this.additionalCase,
      this.caseColor, this.isVisible,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              caseEntity,
              style: const TextStyle(color: Colors.grey, fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
              cases.toString(),
              style: TextStyle(
                  color: caseColor, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Visibility(
              visible: isVisible,
              child: Text(additionalCase,
                  style: TextStyle(color: caseColor, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
