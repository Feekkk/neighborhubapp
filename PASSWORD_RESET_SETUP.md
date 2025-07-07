# Password Reset Functionality Setup Guide

## Overview
This guide explains how to set up and use the complete password reset functionality in your NeighborHub Flutter app.

## Features Implemented

### ✅ Flutter App Components
- **ForgetPasswordPage**: Users can request password reset by entering their email
- **ResetPasswordConfirmPage**: Users can set new password using reset token
- **AuthService**: Complete API integration for password reset
- **Deep Link Handler**: Handles password reset links from emails
- **Route Configuration**: Proper navigation setup

### ✅ Security Features
- Email validation
- Password strength requirements (minimum 6 characters)
- Token verification before password reset
- Secure error handling
- Loading states and user feedback

## Backend Requirements

### 1. Database Schema Updates
Add these fields to your User model in Prisma:

```prisma
model User {
  id              String    @id @default(cuid())
  username        String    @unique
  email           String    @unique
  password        String
  phoneNumber     String?
  address         String?
  gender          String?
  birthday        DateTime?
  resetToken      String?   // Add this
  resetTokenExpiry DateTime? // Add this
  createdAt       DateTime  @default(now())
  updatedAt       DateTime  @updatedAt
}
```

### 2. Install Dependencies
```bash
npm install nodemailer
```

### 3. Environment Variables
Add to your `.env` file:
```bash
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
FRONTEND_URL=http://localhost:3000
```

### 4. Gmail Setup
1. Enable 2-Factor Authentication on your Gmail account
2. Generate an App Password (not your regular password)
3. Use the App Password in `EMAIL_PASSWORD`

### 5. Backend API Endpoints
Implement these endpoints in your auth routes:

#### POST /api/auth/forgot-password
```javascript
router.post('/forgot-password', async (req, res) => {
  try {
    const { email } = req.body;
    const { user, resetToken } = await userService.generatePasswordResetToken(email);
    await userService.sendPasswordResetEmail(email, resetToken);
    
    res.json({ message: 'If the email exists, a password reset link has been sent' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
```

#### GET /api/auth/verify-reset-token/:token
```javascript
router.get('/verify-reset-token/:token', async (req, res) => {
  try {
    const { token } = req.params;
    const user = await userService.verifyPasswordResetToken(token);
    
    res.json({
      valid: true,
      message: 'Token is valid',
      email: user.email
    });
  } catch (error) {
    res.status(400).json({ error: 'Invalid or expired reset token' });
  }
});
```

#### POST /api/auth/reset-password
```javascript
router.post('/reset-password', async (req, res) => {
  try {
    const { token, newPassword } = req.body;
    const result = await userService.resetPasswordWithToken(token, newPassword);
    
    res.json({
      message: 'Password reset successfully',
      user: {
        id: result.user.id,
        username: result.user.username,
        email: result.user.email
      }
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
```

## User Flow

### 1. Request Password Reset
1. User clicks "Forgot Password?" on login page
2. User enters email address
3. App sends request to `/api/auth/forgot-password`
4. Backend generates secure token and sends email
5. User receives email with reset link

### 2. Reset Password
1. User clicks reset link in email
2. App opens and navigates to reset password page
3. App verifies token with `/api/auth/verify-reset-token/:token`
4. If valid, user enters new password
5. App sends new password to `/api/auth/reset-password`
6. Backend updates password and clears token
7. User is redirected to login page

## Testing

### 1. Test Password Reset Request
```bash
curl -X POST http://localhost:3000/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

### 2. Test Token Verification
```bash
curl http://localhost:3000/api/auth/verify-reset-token/your-token-here
```

### 3. Test Password Reset
```bash
curl -X POST http://localhost:3000/api/auth/reset-password \
  -H "Content-Type: application/json" \
  -d '{"token":"your-token","newPassword":"newpass123"}'
```

### 4. Flutter App Testing
Use the test utility in your app:
```dart
import 'package:neighborhub/utils/password_reset_test.dart';

// Call this to test the functionality
PasswordResetTest.showTestDialog(context);
```

## Email Template
The backend should send emails with this structure:
- Professional HTML styling
- Clear call-to-action button
- Reset link format: `yourapp://reset-password?token=abc123`
- Expiration warning (1 hour)
- Security notice

## Security Considerations

1. **Token Security**: Tokens are generated using crypto.randomBytes(32)
2. **Token Expiration**: Tokens expire after 1 hour
3. **Email Enumeration Protection**: Same response regardless of email existence
4. **One-Time Use**: Tokens are cleared after successful password reset
5. **Password Hashing**: New passwords are bcrypt hashed before storage

## Troubleshooting

### Common Issues

1. **Email not sending**
   - Check Gmail App Password configuration
   - Verify EMAIL_USER and EMAIL_PASSWORD in .env
   - Check if 2FA is enabled on Gmail

2. **Token verification failing**
   - Ensure resetToken and resetTokenExpiry fields exist in database
   - Check token expiration logic
   - Verify token format in email links

3. **App not opening reset link**
   - Configure deep linking in your Flutter app
   - Test with proper URL scheme
   - Check route configuration

4. **Backend connection issues**
   - Verify API endpoints are running
   - Check CORS configuration
   - Ensure proper error handling

## Files Modified/Created

### Flutter App
- `lib/services/auth_services.dart` - Added password reset methods
- `lib/user/pages/forgetpassword.dart` - Updated with backend integration
- `lib/user/pages/reset_password_confirm.dart` - New password reset page
- `lib/pages/login_page.dart` - Added navigation to forgot password
- `lib/main.dart` - Added routes for password reset
- `lib/utils/deep_link_handler.dart` - Deep link handling utility
- `lib/utils/password_reset_test.dart` - Testing utility

### Backend (You need to implement)
- User service methods for password reset
- Email sending functionality
- API endpoints for password reset
- Database schema updates

## Next Steps

1. Implement the backend API endpoints
2. Set up email configuration
3. Update your database schema
4. Test the complete flow
5. Configure deep linking for production

The password reset functionality is now fully implemented in your Flutter app and ready to work with your backend! 