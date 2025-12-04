enum Country {
  Russia(GDP: 5327, nationalDebt: 200.5, population: 144713314),
  China(GDP: 30327, nationalDebt: 14000.1, population: 1425887337),
  USA(GDP: 25463, nationalDebt: 33400.0, population: 338289857),
  India(GDP: 11875, nationalDebt: 600.7, population: 1417173173);

  const Country({
    required this.GDP,
    required this.nationalDebt,
    required this.population,
  });

  final int GDP; // ВВП в млрд. долларов
  final double nationalDebt; // млрд. долларов
  final int population; // млн. человек

  double get GDP2debt => (nationalDebt / GDP);
  double get deptOneMan => nationalDebt / population;

  @override
  String toString() {
    return '${this.name}($GDP, $nationalDebt, $population)';
  }
}

(String, int) whatCountry(Country country) {
  return switch (country) {
    Country.Russia => (
        'ε(´｡•᎑•`)っ 💕 ${country.name}',
        country.index,
      ),
    Country.China => (
        '😎 ${country.name}',
        country.index,
      ),
    Country.USA => (
        '凸( •̀_•́ )凸 ${country.name}',
        country.index,
      ),
    Country.India => (
        '🛕 ${country.name}',
        country.index,
      ),
  };
}

void main() {
  var russia = Country.Russia;
  print(russia); // Russia(5327, 200.5, 144713314)
  print(russia.GDP); // 5327
  print(russia.nationalDebt); // 200.5
  print(russia.population); // 144713314
  print(russia.GDP2debt); // 0.03763844565421438
  print(russia.deptOneMan); // 0.0000013854979507967042

  print(whatCountry(russia)); // (ε(´｡•᎑•`)っ 💕 Russia, 0)
  print(whatCountry(Country.India)); // (🛕 India, 3)
  print(whatCountry(Country.China)); // (😎 China, 1)
  print(whatCountry(Country.USA)); // (凸( •̀_•́ )凸 USA, 2)
}
