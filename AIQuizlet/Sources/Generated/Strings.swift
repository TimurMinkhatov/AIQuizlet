// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Auth {
    /// Already have an account? Sign In
    public static let switchToLogin = L10n.tr("Localizable", "auth.switchToLogin", fallback: "Already have an account? Sign In")
    /// Don't have an account? Register
    public static let switchToRegister = L10n.tr("Localizable", "auth.switchToRegister", fallback: "Don't have an account? Register")
    public enum ConfirmPassword {
      /// Confirm Password
      public static let label = L10n.tr("Localizable", "auth.confirmPassword.label", fallback: "Confirm Password")
      /// Repeat password
      public static let placeholder = L10n.tr("Localizable", "auth.confirmPassword.placeholder", fallback: "Repeat password")
    }
    public enum Email {
      /// Email
      public static let label = L10n.tr("Localizable", "auth.email.label", fallback: "Email")
      /// example@email.com
      public static let placeholder = L10n.tr("Localizable", "auth.email.placeholder", fallback: "example@email.com")
    }
    public enum Error {
      /// Invalid email format
      public static let invalidEmail = L10n.tr("Localizable", "auth.error.invalidEmail", fallback: "Invalid email format")
      /// Passwords do not match
      public static let passwordMismatch = L10n.tr("Localizable", "auth.error.passwordMismatch", fallback: "Passwords do not match")
      /// Password must be at least 6 characters
      public static let weakPassword = L10n.tr("Localizable", "auth.error.weakPassword", fallback: "Password must be at least 6 characters")
    }
    public enum Login {
      /// Sign In
      public static let button = L10n.tr("Localizable", "auth.login.button", fallback: "Sign In")
      /// Sign in to your account
      public static let subtitle = L10n.tr("Localizable", "auth.login.subtitle", fallback: "Sign in to your account")
      /// Welcome Back!
      public static let title = L10n.tr("Localizable", "auth.login.title", fallback: "Welcome Back!")
    }
    public enum Password {
      /// Password
      public static let label = L10n.tr("Localizable", "auth.password.label", fallback: "Password")
      /// ······
      public static let placeholder = L10n.tr("Localizable", "auth.password.placeholder", fallback: "······")
      /// At least 6 characters
      public static let registerPlaceholder = L10n.tr("Localizable", "auth.password.registerPlaceholder", fallback: "At least 6 characters")
    }
    public enum Register {
      /// Register
      public static let button = L10n.tr("Localizable", "auth.register.button", fallback: "Register")
      /// Register to get started
      public static let subtitle = L10n.tr("Localizable", "auth.register.subtitle", fallback: "Register to get started")
      /// Create Account
      public static let title = L10n.tr("Localizable", "auth.register.title", fallback: "Create Account")
    }
  }
  public enum Common {
    /// Cancel
    public static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Loading...
    public static let loading = L10n.tr("Localizable", "common.loading", fallback: "Loading...")
    /// OK
    public static let ok = L10n.tr("Localizable", "common.ok", fallback: "OK")
    public enum Error {
      /// No internet connection
      public static let noInternet = L10n.tr("Localizable", "common.error.noInternet", fallback: "No internet connection")
      /// Server error. Please try again
      public static let serverError = L10n.tr("Localizable", "common.error.serverError", fallback: "Server error. Please try again")
      /// Error
      public static let title = L10n.tr("Localizable", "common.error.title", fallback: "Error")
    }
  }
  public enum History {
    /// Test History
    public static let title = L10n.tr("Localizable", "history.title", fallback: "Test History")
    public enum Questions {
      /// %d questions
      public static func count(_ p1: Int) -> String {
        return L10n.tr("Localizable", "history.questions.count", p1, fallback: "%d questions")
      }
    }
    public enum Search {
      /// Search by title...
      public static let placeholder = L10n.tr("Localizable", "history.search.placeholder", fallback: "Search by title...")
    }
  }
  public enum Home {
    /// Hello! 👋
    public static let greeting = L10n.tr("Localizable", "home.greeting", fallback: "Hello! 👋")
    public enum CreateFromPhoto {
      /// Take a photo of your notes and get a ready test
      public static let subtitle = L10n.tr("Localizable", "home.createFromPhoto.subtitle", fallback: "Take a photo of your notes and get a ready test")
      /// Create Test from Notes
      public static let title = L10n.tr("Localizable", "home.createFromPhoto.title", fallback: "Create Test from Notes")
    }
    public enum CreateFromText {
      /// Paste or enter your lecture text
      public static let subtitle = L10n.tr("Localizable", "home.createFromText.subtitle", fallback: "Paste or enter your lecture text")
      /// Create from Text
      public static let title = L10n.tr("Localizable", "home.createFromText.title", fallback: "Create from Text")
    }
    public enum Empty {
      /// Create your first one!
      public static let subtitle = L10n.tr("Localizable", "home.empty.subtitle", fallback: "Create your first one!")
      /// No tests yet
      public static let title = L10n.tr("Localizable", "home.empty.title", fallback: "No tests yet")
    }
    public enum RecentQuizzes {
      /// Recent Tests
      public static let title = L10n.tr("Localizable", "home.recentQuizzes.title", fallback: "Recent Tests")
    }
  }
  public enum Profile {
    /// Profile
    public static let title = L10n.tr("Localizable", "profile.title", fallback: "Profile")
    /// Version %@
    public static func version(_ p1: Any) -> String {
      return L10n.tr("Localizable", "profile.version", String(describing: p1), fallback: "Version %@")
    }
    public enum DeleteData {
      /// Clear All Data
      public static let button = L10n.tr("Localizable", "profile.deleteData.button", fallback: "Clear All Data")
      /// Cancel
      public static let cancel = L10n.tr("Localizable", "profile.deleteData.cancel", fallback: "Cancel")
      /// Delete
      public static let confirmButton = L10n.tr("Localizable", "profile.deleteData.confirmButton", fallback: "Delete")
      /// This will delete all created tests and results. This action cannot be undone.
      public static let message = L10n.tr("Localizable", "profile.deleteData.message", fallback: "This will delete all created tests and results. This action cannot be undone.")
      /// Delete All Data?
      public static let title = L10n.tr("Localizable", "profile.deleteData.title", fallback: "Delete All Data?")
    }
    public enum Language {
      /// English
      public static let english = L10n.tr("Localizable", "profile.language.english", fallback: "English")
      /// Русский
      public static let russian = L10n.tr("Localizable", "profile.language.russian", fallback: "Русский")
      /// Language
      public static let title = L10n.tr("Localizable", "profile.language.title", fallback: "Language")
    }
    public enum Logout {
      /// Sign Out
      public static let button = L10n.tr("Localizable", "profile.logout.button", fallback: "Sign Out")
      /// Cancel
      public static let cancel = L10n.tr("Localizable", "profile.logout.cancel", fallback: "Cancel")
      /// Sign Out
      public static let confirmButton = L10n.tr("Localizable", "profile.logout.confirmButton", fallback: "Sign Out")
      /// You can sign in again at any time.
      public static let message = L10n.tr("Localizable", "profile.logout.message", fallback: "You can sign in again at any time.")
      /// Are you sure you want to sign out?
      public static let title = L10n.tr("Localizable", "profile.logout.title", fallback: "Are you sure you want to sign out?")
    }
    public enum Settings {
      /// Settings
      public static let title = L10n.tr("Localizable", "profile.settings.title", fallback: "Settings")
    }
    public enum Stats {
      /// Average Score
      public static let averageScore = L10n.tr("Localizable", "profile.stats.averageScore", fallback: "Average Score")
      /// Best Score
      public static let bestScore = L10n.tr("Localizable", "profile.stats.bestScore", fallback: "Best Score")
      /// Questions Solved
      public static let totalCompleted = L10n.tr("Localizable", "profile.stats.totalCompleted", fallback: "Questions Solved")
      /// Total Tests
      public static let totalQuizzes = L10n.tr("Localizable", "profile.stats.totalQuizzes", fallback: "Total Tests")
    }
    public enum Theme {
      /// Dark
      public static let dark = L10n.tr("Localizable", "profile.theme.dark", fallback: "Dark")
      /// Light
      public static let light = L10n.tr("Localizable", "profile.theme.light", fallback: "Light")
      /// System
      public static let system = L10n.tr("Localizable", "profile.theme.system", fallback: "System")
      /// Appearance
      public static let title = L10n.tr("Localizable", "profile.theme.title", fallback: "Appearance")
    }
  }
  public enum Quiz {
    public enum Answer {
      /// Option %@ — %@
      public static func option(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "quiz.answer.option", String(describing: p1), String(describing: p2), fallback: "Option %@ — %@")
      }
    }
    public enum Explanation {
      /// Correct answer based on the provided text.
      public static let `default` = L10n.tr("Localizable", "quiz.explanation.default", fallback: "Correct answer based on the provided text.")
      /// Explanation:
      public static let title = L10n.tr("Localizable", "quiz.explanation.title", fallback: "Explanation:")
    }
    public enum Finish {
      /// Finish Test
      public static let button = L10n.tr("Localizable", "quiz.finish.button", fallback: "Finish Test")
    }
    public enum Next {
      /// Next
      public static let button = L10n.tr("Localizable", "quiz.next.button", fallback: "Next")
    }
    public enum Question {
      /// Question %d of %d
      public static func counter(_ p1: Int, _ p2: Int) -> String {
        return L10n.tr("Localizable", "quiz.question.counter", p1, p2, fallback: "Question %d of %d")
      }
      /// Question %d: %@
      public static func title(_ p1: Int, _ p2: Any) -> String {
        return L10n.tr("Localizable", "quiz.question.title", p1, String(describing: p2), fallback: "Question %d: %@")
      }
    }
    public enum Result {
      /// Correct!
      public static let correct = L10n.tr("Localizable", "quiz.result.correct", fallback: "Correct!")
      /// Incorrect
      public static let incorrect = L10n.tr("Localizable", "quiz.result.incorrect", fallback: "Incorrect")
    }
    public enum TextInput {
      /// %d / 5000 characters
      public static func characterCount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "quiz.textInput.characterCount", p1, fallback: "%d / 5000 characters")
      }
      /// Minimum recommended length is 50 characters
      public static let minLength = L10n.tr("Localizable", "quiz.textInput.minLength", fallback: "Minimum recommended length is 50 characters")
      /// Paste lecture text, notes or textbook...
      public static let placeholder = L10n.tr("Localizable", "quiz.textInput.placeholder", fallback: "Paste lecture text, notes or textbook...")
      /// Number of questions
      public static let questionCount = L10n.tr("Localizable", "quiz.textInput.questionCount", fallback: "Number of questions")
      /// Enter text
      public static let title = L10n.tr("Localizable", "quiz.textInput.title", fallback: "Enter text")
      public enum Generate {
        /// Generate test
        public static let button = L10n.tr("Localizable", "quiz.textInput.generate.button", fallback: "Generate test")
      }
      public enum Paste {
        /// Paste
        public static let button = L10n.tr("Localizable", "quiz.textInput.paste.button", fallback: "Paste")
      }
    }
  }
  public enum Result {
    /// %d of %d correct answers
    public static func correctCount(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "result.correctCount", p1, p2, fallback: "%d of %d correct answers")
    }
    public enum Breakdown {
      /// Question Breakdown
      public static let title = L10n.tr("Localizable", "result.breakdown.title", fallback: "Question Breakdown")
    }
    public enum Home {
      /// Home
      public static let button = L10n.tr("Localizable", "result.home.button", fallback: "Home")
    }
    public enum TryAgain {
      /// Try Again
      public static let button = L10n.tr("Localizable", "result.tryAgain.button", fallback: "Try Again")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
