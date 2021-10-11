document.addEventListener('DOMContentLoaded', () => {
  document.querySelector('#flag_type')?.addEventListener('change', (event) => {
    if (event.target.value === 'regex') {
      document.querySelector('label[for="challenge_flag"]').innerText = "Regex Flag";
      document.querySelector('#challenge_flag').placeholder = "/ARegex Flag Here/Z";
      document.querySelector('#case_insensitive').classList.remove('invisible');
    } else {
      document.querySelector('label[for="challenge_flag"]').innerText = "Flag";
      document.querySelector('#challenge_flag').placeholder = "";
      document.querySelector('#case_insensitive').classList.add('invisible');
      document.querySelector('#challenge_case_insensitive').checked = false;
    }
  });
 });
