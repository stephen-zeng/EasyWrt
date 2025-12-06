# Quickstart: EasyWrt Core Features

## Prerequisites
- Flutter SDK installed (latest stable channel recommended)
- An OpenWrt device reachable via network OR use the Unit Tests to verify logic.

## Setup
1. **Get Dependencies**:
   ```bash
   flutter pub get
   ```
2. **Generate Code** (for Hive models):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Running the Application
You can run the application on macOS, Windows, or Linux.

1. **Launch App**:
   ```bash
   flutter run -d macos
   # or
   flutter run -d windows
   # or
   flutter run -d linux
   ```

2. **First Run**:
   - The app will launch to the Device List page (initially empty).
   - Click "+" to add a new device.

3. **Add Device**:
   - **Name**: Any friendly name (e.g., "Home Router")
   - **Hostname**: IP address (e.g., `192.168.1.1`)
   - **Port**: `80` or `443`
   - **Protocol**: `http` or `https`
   - **Username**: Usually `root`
   - **Password**: Your router password
   - **RPC Root Path**: Defaults to `/cgi-bin/luci/rpc` (Change only if custom)

4. **Dashboard**:
   - Once added, click the device card to enter the Dashboard.
   - In **Portrait** mode: You see the "Function Details" pane. Use the Menu button in AppBar to switch views.
   - In **Landscape** mode: You see a split view with Sidebar (Middleware) and Content.

## Testing Features

### Bio-Authentication (User Story 3)
1. Go to **Settings** (via gear icon or menu).
2. Enable "Biometric Authentication".
3. Restart the app. You should be prompted for Fingerprint/FaceID/Password.

### MCP Server (User Story 4)
1. Go to **Settings**.
2. Enable "MCP Server".
3. The app logs will show "MCP Server listening on ...".
4. You can interact with the MCP server via HTTP POST to `/mcp` endpoint on the configured port (default 3000 or similar).
   - **Example Request**:
     ```json
     {
       "jsonrpc": "2.0",
       "method": "list_devices",
       "id": 1
     }
     ```

## Running Tests
To verify logic without a device, run the test suite:

```bash
flutter test
```
This includes:
- `device_repository_test.dart`: Verifies storage logic.
- `dashboard_page_test.dart`: Verifies responsive layout.
- `bio_auth_service_test.dart`: Verifies auth logic.
- `mcp_server_test.dart`: Verifies MCP tool execution.
