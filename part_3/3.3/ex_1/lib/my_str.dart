List<String> splitString(String line, String splitter){
  return line.split(splitter);
}

String stringToLowerCase(String line){
  return line.toLowerCase();
}

String stringToUpperCase(String line){
  return line.toUpperCase();
}

String deleteSurroundingSpaces(String line) => line.trim();
