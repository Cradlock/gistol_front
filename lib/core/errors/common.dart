class ContractMismatchError extends Error {
  final String path;
  final Type targetType;
  final Object originalError;
  final StackTrace? originalStackTrace;

  ContractMismatchError({
    required this.path,
    required this.targetType,
    required this.originalError,
    this.originalStackTrace,
  });

  @override
  String toString() {
    return '🔥 [Contract Mismatch Error]:\n'
           '• Endpoint: $path\n'
           '• Expected Model (Type): $targetType\n'
           '• Reason: $originalError\n'
           '${originalStackTrace != null ? '• StackTrace:\n$originalStackTrace' : ''}';
  }
}
