#!/usr/bin/env python3
import os
import subprocess
from flask import Flask, render_template, request, send_file, flash, redirect, url_for
from datetime import datetime
import tempfile
import shutil

app = Flask(__name__)
app.secret_key = 'your-secret-key-change-this'  # Change this to a secure secret key

# Directory where your logs are stored (adjust as needed)
LOG_DIRECTORY = "/path/to/your/logs"

def run_log_script(date, utrnno):
    """
    This function will call your existing log archiving script.
    Replace this with the actual call to your script.
    """
    try:
        # Create a temporary directory for the archive
        temp_dir = tempfile.mkdtemp()
        archive_path = os.path.join(temp_dir, f"logs_{date}_{utrnno}.tar.gz")
        
        # TODO: Replace this with your actual script call
        # Example: subprocess.run(['./your_script.sh', date, utrnno, archive_path], check=True)
        
        # For now, create a dummy archive (remove this when integrating your script)
        subprocess.run(['tar', 'czf', archive_path, '--files-from', '/dev/null'], check=True)
        
        return archive_path if os.path.exists(archive_path) else None
        
    except subprocess.CalledProcessError as e:
        print(f"Error running script: {e}")
        return None
    except Exception as e:
        print(f"Unexpected error: {e}")
        return None

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        date = request.form.get('date')
        utrnno = request.form.get('utrnno')
        
        # Validate inputs
        if not date or not utrnno:
            flash('Please provide both date and UTRN number', 'error')
            return redirect(url_for('index'))
        
        # Validate date format
        try:
            datetime.strptime(date, '%Y-%m-%d')
        except ValueError:
            flash('Please provide date in YYYY-MM-DD format', 'error')
            return redirect(url_for('index'))
        
        # Run the log archiving script
        archive_path = run_log_script(date, utrnno)
        
        if archive_path and os.path.exists(archive_path):
            flash(f'Archive created successfully for date {date} and UTRN {utrnno}', 'success')
            return send_file(
                archive_path,
                as_attachment=True,
                download_name=f"logs_{date}_{utrnno}.tar.gz",
                mimetype='application/gzip'
            )
        else:
            flash('No logs found for the specified date and UTRN number', 'error')
            return redirect(url_for('index'))
    
    return render_template('index.html')

@app.route('/health')
def health():
    """Simple health check endpoint"""
    return {'status': 'ok'}

if __name__ == '__main__':
    # Create templates directory if it doesn't exist
    os.makedirs('templates', exist_ok=True)
    
    app.run(debug=True, host='0.0.0.0', port=5000)