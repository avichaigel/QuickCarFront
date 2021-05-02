// Widget _buildManufYear() {
//   return DropdownButton<String>(
//       value: DateTime.now().year.toString(),
//       elevation: 20,
//       onChanged: (String year) {
//         _manufYear = int.parse(year);
//         value = year
//       }
//       items: List<String>
//       .generate(_currentYear - _startYear, (i) => (i + _startYear + 1).toString())
//       .toList()
//       .map<DropdownMenuItem<String>>((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: Text(value),
//     );
//   }).toList(),
//   );