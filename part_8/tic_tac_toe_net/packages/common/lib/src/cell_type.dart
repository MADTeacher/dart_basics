enum Cell {
  empty('.'),
  cross('X'),
  nought('O');

  final String symbol;

  const Cell(this.symbol);
}
