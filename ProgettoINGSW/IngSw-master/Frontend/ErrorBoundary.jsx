import React from "react";

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error("Error Boundary catturato:", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{ textAlign: "center", marginTop: "50px" }}>
          <h1>Si è verificato un errore</h1>
          <p>{this.state.error?.message || "Errore sconosciuto."}</p>
        </div>
      );
    }
    return this.props.children;
  }
}

export default ErrorBoundary;