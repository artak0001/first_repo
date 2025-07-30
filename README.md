# Log Archive Web Interface

A simple web interface for searching and downloading log archives by date and UTRN number.

## Features

- Clean, modern web interface
- Date picker for easy date selection
- UTRN number input field
- Automatic archive download
- Error handling and user feedback
- Responsive design

## Setup

### Quick Start (Recommended)
Simply run the provided script:
```bash
./run_app.sh
```

This script will automatically:
- Create a virtual environment if it doesn't exist
- Install all dependencies
- Start the Flask application

### Manual Setup
1. Create and activate a virtual environment:
```bash
python3 -m venv log_archive_env
source log_archive_env/bin/activate
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

3. Update the `app.py` file:
   - Replace the `run_log_script()` function with your actual log archiving script
   - Update the `LOG_DIRECTORY` variable to point to your log directory
   - Change the `secret_key` to a secure random string

4. Run the application:
```bash
python app.py
```

5. Open your browser and go to `http://localhost:5000`

## Integration with Your Script

To integrate your existing log archiving script, modify the `run_log_script()` function in `app.py`:

```python
def run_log_script(date, utrnno):
    try:
        temp_dir = tempfile.mkdtemp()
        archive_path = os.path.join(temp_dir, f"logs_{date}_{utrnno}.tar.gz")
        
        # Replace this line with your actual script call
        subprocess.run(['./your_script.sh', date, utrnno, archive_path], check=True)
        
        return archive_path if os.path.exists(archive_path) else None
    except subprocess.CalledProcessError:
        return None
```

## Usage

1. Select the date you want to search logs for
2. Enter the UTRN number you're looking for
3. Click "Search & Download Archive"
4. The archive will be automatically downloaded if logs are found

## File Structure

```
.
├── app.py              # Main Flask application
├── templates/
│   └── index.html      # Web interface template
├── requirements.txt    # Python dependencies
├── run_app.sh          # Easy startup script
├── log_archive_env/    # Virtual environment (created automatically)
└── README.md          # This file
```

## Security Notes

- Change the `secret_key` in `app.py` for production use
- Consider adding authentication if needed
- Validate and sanitize all user inputs
- Run behind a reverse proxy (nginx/Apache) in production