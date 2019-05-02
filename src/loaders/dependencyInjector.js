const { Container } =  require('typedi');

module.exports = (dependencies = []) => {
    try {
        dependencies.forEach(dependency => {
            Container.set(dependency.name, dependency.service)
        });
    } catch (error) {
        console.log('🔥 Error on dependency injector loader %o', e);
        throw e;
    }
}