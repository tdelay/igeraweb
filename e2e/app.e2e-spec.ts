import { IgeraWebPage } from './app.po';

describe('igera-web App', function() {
  let page: IgeraWebPage;

  beforeEach(() => {
    page = new IgeraWebPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
