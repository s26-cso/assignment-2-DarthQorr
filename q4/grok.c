int grok(int a, int b) {
    if (b == 0) return 0; // Simple safety check
    return (a << 3) ^ (b / 2);
}