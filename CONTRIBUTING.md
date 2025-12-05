# 🤝 Guia de Contribuição

Obrigado por considerar contribuir com o **MyDistroLinux Builder**! 🎉

Este guia ajudará você a entender como contribuir de forma eficaz.

---

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Workflow Git](#workflow-git)
- [Padrões de Código](#padrões-de-código)
- [Commits e Mensagens](#commits-e-mensagens)
- [Pull Requests](#pull-requests)
- [Issues](#issues)
- [Testes](#testes)

---

## 🤝 Código de Conduta

Este projeto segue um código de conduta simples:

- ✅ Seja respeitoso e profissional
- ✅ Aceite críticas construtivas
- ✅ Foque no que é melhor para a comunidade
- ❌ Não use linguagem ofensiva ou inadequada
- ❌ Não publique informações privadas de terceiros

---

## 🚀 Como Contribuir

### 1️⃣ Reportar Bugs

Use o template de **Bug Report** para reportar problemas:

1. Vá em **Issues** → **New Issue**
2. Selecione **🐛 Bug Report**
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
