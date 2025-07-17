import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor"]

  connect() {
    // Fully cleanup any existing editor for this textarea
    const id = this.editorTarget.id;
    if (tinymce.EditorManager.get(id)) {
      tinymce.EditorManager.execCommand('mceRemoveEditor', true, id);
    }

    tinymce.init({
      target: this.editorTarget,
      selector: null,
      plugins: ["lists", "link", "image", "table", "code", "help", "wordcount"],
      toolbar: "undo redo | bold italic underline | bullist numlist | link image table | code help wordcount",
      
      automatic_uploads: true,
      images_upload_url: '/uploader/image',

      relative_urls: false,
      remove_script_host: true, 

      images_upload_handler: (blobInfo, progress) =>
        new Promise((resolve, reject) => {
          const xhr = new XMLHttpRequest();
          xhr.open('POST', '/uploader/image');
          xhr.onload = () => {
            const json = JSON.parse(xhr.responseText);
            let src = json.location;
            if (src.startsWith('../')) {
              src = src.replace(/^(\.\.\/)+/, '/'); // "../rails/... → /rails/..."
            }
            resolve(src);
          };

          /*xhr.onload = () => {
            if (xhr.status >= 200 && xhr.status < 300) {
              const json = JSON.parse(xhr.responseText);
              resolve(json.location);
            } else {
              reject('Upload failed: ' + xhr.status);
            }
          };*/
          xhr.onerror = () => reject('Network error');
          // ファイル送信は以下だけでOK
          const formData = new FormData();
          formData.append('file', blobInfo.blob(), blobInfo.filename());
          xhr.send(formData);
        }),
      content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',
    });
  }

  disconnect() {
    const id = this.editorTarget.id;
    if (tinymce.EditorManager.get(id)) {
      tinymce.EditorManager.execCommand('mceRemoveEditor', true, id);
    }
  }
}
