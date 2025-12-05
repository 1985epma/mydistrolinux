# Contributing to MyDistroLinux

Obrigado por considerar contribuir com o MyDistroLinux! 🎉

## Como Contribuir

### Reportando Bugs

1. Verifique se o bug já não foi reportado nas [Issues](https://github.com/1985epma/mydistrolinux/issues)
2. Abra uma nova issue com o template de bug
3. Inclua informações detalhadas:
   - Sistema operacional e versão
   - Logs relevantes (`/tmp/*.log`)
   - Passos para reproduzir o problema

### Sugerindo Melhorias

1. Abra uma issue com o template de feature request
2. Descreva claramente a funcionalidade desejada
3. Explique o caso de uso

### Pull Requests

1. **Fork** o repositório
2. Crie uma **branch** para sua feature:
   ```bash
   git checkout -b feat/minha-feature
   ```

3. **Commit** suas mudanças seguindo a convenção:
   ```bash
   git commit -m "feat: adicionar suporte para Debian"
   ```

4. **Push** para sua branch:
   ```bash
   git push origin feat/minha-feature
   ```

5. Abra um **Pull Request**

## Convenção de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `docs:` - Documentação
- `style:` - Formatação
- `refactor:` - Refatoração de código
- `test:` - Testes
- `chore:` - Tarefas de manutenção

**Exemplos**:
```bash
feat: adicionar suporte para Arch Linux
fix: corrigir erro no grub-mkstandalone
docs: atualizar instruções de instalação
refactor: melhorar função de validação
```

## Padrões de Código

### Bash
- Use `shellcheck` para validar
- Indentação: 2 espaços
- Use `set -e` para parar em erros
- Comente código complexo

### Markdown
- Use markdownlint
- Máximo de 120 caracteres por linha
- Use headers hierárquicos

## Testes

Antes de submeter PR:

```bash
# Validar sintaxe
bash -n distro.sh

# Executar shellcheck
shellcheck distro.sh

# Testar localmente (em VM)
./distro.sh
```

## Processo de Review

1. Todos os PRs passam por CI/CD
2. Pelo menos 1 aprovação necessária
3. Testes devem passar
4. Code review pelo mantenedor

## Código de Conduta

- Seja respeitoso e construtivo
- Foco na melhoria do projeto
- Ajude outros contribuidores

## Dúvidas?

Abra uma [Discussion](https://github.com/1985epma/mydistrolinux/discussions) ou entre em contato!
